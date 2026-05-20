# CaptureFlow-Design.md — Still Hours

> Version 1.0 | 2026-05-20 | Design.MD §5.5 / PRD §9 Module 3 정합
> 3-second capture sheet 완전 spec. CaptureFlow Module 외부 인터페이스 `startCapture() → CaptureSession` 의 UI 구현 전체.

---

## 1. 목적 — 왜 3초인가

무거운 컬렉션 앱은 항목 하나 등록에 20개 이상의 필드를 요구한다. 제목, 저자, 연도, 출판사, ISBN, 언어, 태그, 상태, 컬렉션 선택… 결과적으로 사용자는 현장에서 등록하지 않고 집에 돌아와 "나중에 입력하자"고 미룬다. 미뤄진 입력은 기억과 분리된다.

Still Hours의 3초 캡처는 이 패턴을 뒤집는다. **자산 등록과 기억 보존을 분리하지 않는다.** 책을 구입한 바로 그 순간, 영수증을 받기 전에, Item이 컬렉션에 들어오고 첫 Memory가 자동 생성된다.

이것이 PRD Hero Moment 1 "Story Capture"의 구체다:

```
바코드 스캔 (1초) → 메타데이터 자동 (1초) → 음성 메모 "왜?" (1초) → 저장
```

최소 필드: 제목 + 매체(medium) 2개만 필수. 나머지는 전부 자동(날짜 = now, 장소 = CoreLocation) 또는 선택(제작자, 커버 이미지). "Power tucked away" — Things 3 정신.

---

## 2. 세 가지 진입 모드

### Mode A — 바코드 스캔

**대상 자산**: 종이책(ISBN), CD/LP(UPC/EAN), DVD(UPC/EAN)

**외부 조회 체인**:

| 식별자 | 조회 소스 |
|--------|----------|
| ISBN-10 / ISBN-13 | Open Library API → Google Books fallback |
| UPC / EAN (음악) | MusicBrainz → Discogs fallback |
| UPC / EAN (영상) | TMDB fallback |
| 식별 실패 | Mode C(수동) 자동 전환 |

바코드 인식 엔진: `AVCaptureMetadataOutput` — 지원 심볼로지 `[.ean13, .ean8, .upce, .code128]`. ISBN 바코드는 EAN-13 형식.

외부 조회는 `MetadataResolver` Module이 담당 (PRD §9 Module 2). CaptureFlow는 `resolve(query:mediumHint:) → ResolvedMetadata?`만 호출. 사용자 식별 정보 비송신(PRD §7.8) — User-Agent 헤더에 기기 식별자 포함 금지.

### Mode B — 음성 메모

**대상 자산**: 바코드 없는 외서, 수제 오브제, 경험, 장소 — 스캔 불가 항목

**인식 엔진**: `Speech.SFSpeechRecognizer` on-device 모드. 클라우드 STT 미사용(Privacy §12 참조).

지원 locale: `ko-KR`, `en-US`, `ja-JP`.

음성 입력은 두 가지 역할을 한다:
1. **항목명 인식**: 첫 발화 → 제목 필드 자동 채움. 사용자 확인 필요.
2. **첫 Memory 메모**: 확인 후 "왜?" 추가 발화 → `Memory.note`에 자동 기입.

Mode B는 독립 항목 등록 경로이기도 하고, Mode A 성공 후 "왜?" 음성 추가 경로이기도 하다. 두 경우 모두 동일 UI 컴포넌트 `VoiceRecordingView`를 재사용한다.

### Mode C — 수동 입력

**대상 자산**: 디지털 자산, 조회 실패 항목, 정밀 입력이 필요한 항목

**최소 필드 4개**:

| 필드 | 필수 | 입력 방식 |
|------|------|----------|
| `title` | 필수 | TextField, `font.body` 17pt |
| `medium` | 필수 | Segmented picker (Book / Music / Movie / Object) |
| `creator` | 선택 | TextField, placeholder "저자 / 아티스트 / 감독…" |
| `cover` | 선택 | PhotosPicker or Camera — `MediaPicker` |

날짜(`createdAt`) = `Date.now` 자동. 장소 = CoreLocation 자동 제안. 사용자 수정 가능.

Mode C는 Mode A 인식 실패 시 자동 전환된다(state: `notRecognized → manualFallback`). 이 전환은 애니메이션 없이 즉각적이어야 한다(`motion.quick` 200ms 내).

---

## 3. 플로우 다이어그램

### Mode A: 바코드 스캔

```
[사용자가 캡처 시트 열기]
          │
          ▼
    [idle — 카메라 뷰파인더 표시]
          │
          │  바코드 프레임 진입
          ▼
    [scanning — 파인더 corner 강조]
          │
          │  AVCaptureMetadataOutput 인식
          ▼
    [recognized — 진동 햅틱 + 메타데이터 로딩]
          │                │
          │ 조회 성공       │ 조회 실패
          ▼                ▼
    [confirming]     [notRecognized]
    제목/저자/커버       │
    미리보기 카드        ▼
          │         [manualFallback]
          │         Mode C form 전환
          │
          │  사용자 저장 탭
          ▼
    [saving — SwiftData 저장]
          │
          ▼
    [done — 시트 닫힘, Library 업데이트]
```

### Mode B: 음성 메모

```
[사용자가 마이크 버튼 탭]
          │
          │  권한 있음          권한 없음
          ▼                        ▼
    [idle → recording]      [permissionDenied]
    파형 애니메이션 시작      설정 유도 배너 표시
          │
          │  SFSpeechRecognizer 중간 결과
          ▼
    [recognized — 전사 텍스트 미리보기]
          │
          │  사용자 정지 탭
          ▼
    [confirming — 텍스트 편집 가능]
          │
          │  사용자 저장 탭
          ▼
    [saving → done]
```

### Mode C: 수동 입력

```
[폼 표시]
          │
          │  사용자 입력 (title 필수)
          ▼
    [confirming — 필수 필드 채움 감지]
          │
          │  저장 탭
          ▼
    [saving — 검증 → SwiftData 저장]
          │
          │  중복 감지?
          │  Yes                No
          ▼                     ▼
  [duplicate alert]         [done]
  기존 항목 보기 / 새로 추가
```

---

## 4. 시트 레이아웃

캡처 시트는 `.sheet` modifier + `.presentationDetents([.medium, .large])` 로 표시한다. 기본 detent: `.medium`. 수동 입력(Mode C) 키보드 활성 시 `.large`로 자동 확장.

```
┌──────────────────────────────────────┐  ← .sheet .medium detent
│                                      │
│  ┌──────────────────────────────────┐│  ← Liquid Glass toolbar
│  │  [X]  캡처           [전환 토글] ││    .glassEffect(.regular)
│  └──────────────────────────────────┘│
│                                      │
│  ┌──────────────────────────────────┐│  ← 콘텐츠 영역 (모드별 다름)
│  │                                  ││
│  │   Mode A: 카메라 라이브 뷰       ││
│  │   Mode B: 파형 + 전사 텍스트    ││
│  │   Mode C: 4-필드 폼             ││
│  │                                  ││
│  └──────────────────────────────────┘│
│                                      │
│  ┌──────────────────────────────────┐│  ← 하단 액션 바
│  │  [수동]  [음성]  [스캔 / 저장]   ││    .buttonStyle(.glass)
│  └──────────────────────────────────┘│
│                                      │
└──────────────────────────────────────┘
```

### 4.1 상단 툴바

| 요소 | API | 비고 |
|------|-----|------|
| 닫기 버튼 (X) | SF Symbol `xmark`, 22pt, `.buttonStyle(.glass)` | 탭 → 시트 닫힘, 미저장 항목 폐기 |
| 타이틀 "캡처" | `font.heading.2` SF Pro Semibold 17pt, `text.primary` | 중앙 정렬 |
| 모드 전환 토글 | SF Symbol `barcode.viewfinder` / `mic.fill` / `keyboard` | `.buttonStyle(.glass)`, trailing |

툴바 배경: `GlassEffectContainer` 내부에 배치, `.glassEffect(.regular)` 적용. 콘텐츠 영역(카메라 뷰/폼) 위에 오버레이.

### 4.2 콘텐츠 영역

**Mode A (카메라)**

`AVCaptureVideoPreviewLayer`를 `UIViewRepresentable`로 래핑. 뷰파인더 오버레이: 모서리 L자 4개, `accent.default` 색, 2pt 선. 인식 성공 시 L자가 초록으로 전환(`Color.green`) 후 200ms 내 원래 색 복귀.

인식 대기 중 텍스트: `"바코드를 프레임 안에 위치시키세요"` — `font.caption` 12pt, `text.secondary`, 뷰파인더 하단.

```swift
// AVCaptureSession 최소 설정
let session = AVCaptureSession()
session.sessionPreset = .hd1280x720  // 바코드 인식 충분, 4K 불필요

guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                            for: .video,
                                            position: .back),
      let input = try? AVCaptureDeviceInput(device: device) else { return }

session.addInput(input)

let metadataOutput = AVCaptureMetadataOutput()
session.addOutput(metadataOutput)
metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
metadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce, .code128]
```

**Mode B (음성)**

파형 시각화: 16개 막대, 너비 3pt, 간격 3pt, 높이 4pt~32pt (오디오 레벨 연동). 색: 녹음 중 `accent.default`, 미녹음 `accent.muted`. 전사 텍스트는 파형 아래, `font.body` 17pt, `text.primary`, 줄바꿈 가능.

```swift
// SFSpeechRecognizer 초기화 (on-device 모드 강제)
let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
// requiresOnDeviceRecognition = true (iOS 16+)
let request = SFSpeechAudioBufferRecognitionRequest()
request.requiresOnDeviceRecognition = true
request.shouldReportPartialResults = true
```

**Mode C (수동 폼)**

```
│  제목 (필수)
│  ┌──────────────────────────────────┐
│  │ 노르웨이의 숲                    │
│  └──────────────────────────────────┘
│
│  매체
│  [책]  [음악]  [영화]  [물건]
│
│  제작자 (선택)
│  ┌──────────────────────────────────┐
│  │ 저자 / 아티스트 / 감독…         │
│  └──────────────────────────────────┘
│
│  커버 이미지 (선택)
│  [사진 선택]  또는  [카메라]
```

```swift
// PhotosPicker — 커버 이미지
import PhotosUI

PhotosPicker(selection: $coverItem,
             matching: .images,
             photoLibrary: .shared()) {
    Label("사진 선택", systemImage: "photo")
}
.onChange(of: coverItem) { item in
    Task {
        if let data = try? await item?.loadTransferable(type: Data.self) {
            coverImageData = data
        }
    }
}
```

### 4.3 하단 액션 바

`GlassEffectContainer` 내부에 3개 버튼 배치. 버튼 간격 `space.sm` 8pt.

| 버튼 | SF Symbol | 역할 |
|------|----------|------|
| 수동 | `keyboard` | Mode C 전환 |
| 음성 | `mic.fill` | Mode B 전환 / 음성 토글 |
| 스캔 / 저장 | `barcode.viewfinder` / `checkmark.circle.fill` | Mode A 활성 시 스캔 표시, confirming 상태 시 저장 |

저장 버튼 (confirming 상태): `.buttonStyle(.glassProminent)` + `.glassEffect(.regular.tint(Color("accent.default")).interactive())`. 저장 전 상태: `.buttonStyle(.glass)` 비활성.

---

## 5. Liquid Glass 사용 위치

iOS 26 `.sheet` 와 NavigationBar는 Xcode 26 리컴파일 시 Liquid Glass 자동 적용. 아래는 Still Hours가 명시적으로 추가하는 위치다.

| 위치 | API | 변형 |
|------|-----|------|
| 상단 툴바 전체 | `GlassEffectContainer { HStack { ... } }` | `.regular` |
| 닫기(X) / 모드 전환 버튼 | `.buttonStyle(.glass)` | `.regular` |
| 저장 버튼 (confirming) | `.buttonStyle(.glassProminent)` + `.glassEffect(.regular.tint(...).interactive())` | `.regular` + tint `#B85C38` |
| 하단 액션 바 | `GlassEffectContainer { HStack { ... } }` | `.regular` |
| 인식 결과 미리보기 카드 | `.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12))` | `.regular` |

**금지**:
- 카메라 라이브 뷰 레이어 자체에 `.glassEffect()` 적용 — glass-on-content 금지(LiquidGlass-Notes.md §2)
- 폼 텍스트 필드 배경에 glass 적용 — glass-on-glass 금지
- 저장 버튼 외 버튼에 `.tint()` — 모든 tint 주요 액션 1~2곳 한정

---

## 6. 상태 기계 (State Machine)

```
                    ┌─────────┐
                    │  idle   │ ← 시트 열림 초기 상태
                    └────┬────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
    Mode A│        Mode B│        Mode C│
          ▼              ▼              ▼
     [scanning]    [recording]   [editing]
          │              │              │
          │ 인식          │ 정지          │ 입력 완료
          ▼              ▼              ▼
    [recognized]  [transcribed]  [confirmed]
          │              │              │
          └──────────────┴──────────────┘
                         │
                         ▼
                   [confirming] ← 사용자 검토/편집
                         │
                    저장 탭
                         ▼
                    [saving]
                         │
               ┌─────────┴─────────┐
               │ 성공               │ 실패
               ▼                   ▼
            [done]           [error — 배너 표시]
```

**실패 분기 상세**:

| 분기 | 트리거 | 전환 대상 | UX |
|------|--------|----------|----|
| `notRecognized` | 바코드 인식 후 조회 실패 | `manualFallback` = Mode C | 배너: "메타데이터를 찾지 못했습니다. 직접 입력해주세요." |
| `permissionDenied` (카메라) | `AVCaptureDevice.authorizationStatus(.video) == .denied` | 설정 유도 | 배너: "카메라 접근 권한이 필요합니다." + "설정 열기" 버튼 |
| `permissionDenied` (마이크) | `AVAudioSession.recordPermission == .denied` | 설정 유도 | 배너: "마이크 접근 권한이 필요합니다." + "설정 열기" 버튼 |
| `offlineMetadata` | URLSession 네트워크 오류 | `manualFallback` | 배너: "오프라인 상태입니다. 직접 입력해주세요." — 로컬 저장은 정상 |
| `duplicateItem` | InventoryCore dedup 감지 | 선택 alert | "이미 컬렉션에 있습니다. 기억만 추가할까요?" |

---

## 7. SwiftUI 구현 힌트

### 7.1 CaptureView 골격

```swift
struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // 콘텐츠 영역
                Group {
                    switch viewModel.mode {
                    case .barcode:
                        BarcodeScannerView(onRecognized: viewModel.handleBarcode)
                    case .voice:
                        VoiceRecordingView(viewModel: viewModel)
                    case .manual:
                        ManualEntryForm(viewModel: viewModel)
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)

                // 하단 액션 바
                GlassEffectContainer {
                    CaptureActionBar(viewModel: viewModel)
                }
                .padding(.horizontal, 16)  // space.md
                .padding(.bottom, 24)      // space.lg
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.glass)
                }
                ToolbarItem(placement: .principal) {
                    Text("capture.title")  // i18n key
                        .font(.headline.weight(.semibold))
                }
                ToolbarItem(placement: .confirmationAction) {
                    ModeSwitcherButton(viewModel: viewModel)
                        .buttonStyle(.glass)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
```

### 7.2 AVCaptureSession 시작 / 정지

```swift
final class BarcodeScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var onRecognized: (String) -> Void

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput objects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let first = objects.first as? AVMetadataMachineReadableCodeObject,
              let value = first.stringValue else { return }
        DispatchQueue.main.async { self.onRecognized(value) }
    }
}

// 세션은 시트 표시 시 시작, 사라질 때 정지
.onAppear { session.startRunning() }
.onDisappear { session.stopRunning() }
```

### 7.3 SFSpeechRecognizer 흐름

```swift
func startRecording() throws {
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

    let inputNode = audioEngine.inputNode
    let request = SFSpeechAudioBufferRecognitionRequest()
    request.requiresOnDeviceRecognition = true
    request.shouldReportPartialResults = true

    recognitionTask = recognizer?.recognitionTask(with: request) { [weak self] result, error in
        if let result {
            self?.transcript = result.bestTranscription.formattedString
        }
    }

    let format = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
        request.append(buffer)
    }
    try audioEngine.start()
}
```

---

## 8. 사용 SF Symbols

CaptureFlow에서 사용하는 SF Symbols (SFSymbols-Selection.md §2 확정 목록 포함):

| SF Symbol | 위치 | 역할 |
|-----------|------|------|
| `barcode.viewfinder` | 모드 전환 토글 / 하단 스캔 버튼 | 바코드 스캔 모드 진입 |
| `mic.fill` | 모드 전환 토글 / 하단 음성 버튼 | 음성 녹음 모드 진입 |
| `keyboard` | 하단 수동 버튼 | 수동 입력 모드 진입 |
| `photo` | Mode C 커버 이미지 선택 | PhotosPicker 트리거 |
| `checkmark.circle.fill` | 하단 저장 버튼 (confirming 상태) | 저장 확정 |
| `magnifyingglass` | 조회 중 로딩 인디케이터 | MetadataResolver 조회 진행 표시 |
| `xmark` | 툴바 닫기 버튼 | 시트 닫기 |

> 위 7개 외 추가 symbol 도입 금지. 확정되지 않은 symbol은 Open Questions §15에 기재.

---

## 9. 접근성

### 9.1 VoiceOver

| 요소 | accessibilityLabel | accessibilityHint |
|------|-------------------|-------------------|
| 닫기 버튼 | `"닫기"` | `"캡처를 취소하고 돌아갑니다."` |
| 바코드 스캔 버튼 | `"바코드 스캔"` | `"카메라로 바코드를 스캔합니다."` |
| 음성 입력 버튼 | `"음성 입력"` | `"음성으로 항목 제목을 인식합니다."` |
| 수동 입력 버튼 | `"수동 입력"` | `"직접 입력 폼으로 전환합니다."` |
| 저장 버튼 | `"저장"` | `"항목을 컬렉션에 추가합니다."` |
| 카메라 뷰파인더 | `"카메라 뷰파인더. 스캔 대기 중."` | — |
| 스캔 성공 | `"인식됨: \(title) — \(creator)"` | — (UIAccessibility.post announcement) |
| 음성 녹음 중 | `"녹음 중"` | — |
| 전사 결과 | `"인식된 텍스트: \(transcript)"` | — |

```swift
// 인식 성공 시 VoiceOver 발화
UIAccessibility.post(
    notification: .announcement,
    argument: "인식됨: \(resolvedMetadata.title) — \(resolvedMetadata.creator ?? "")"
)
```

### 9.2 Reduced Motion

| 효과 | Reduced Motion = ON |
|------|---------------------|
| 뷰파인더 corner shimmer | 제거 (정적 L자 유지) |
| Liquid Glass specular sweep | 시스템 자동 감쇠 (코드 추가 불필요) |
| 음성 파형 막대 높이 애니메이션 | 정지 — 단일 높이 16pt 고정 막대 |
| 저장 버튼 interactive scale | 제거 |
| 모드 전환 cross-fade | 즉시 전환 (duration = 0) |

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var waveformAnimation: Animation? {
    reduceMotion ? nil : .easeInOut(duration: 0.1)
}
```

### 9.3 Dynamic Type

| 요소 | Ceiling |
|------|---------|
| 제목 레이블 (`font.heading.2` 17pt) | `.accessibility3` |
| 폼 필드 레이블 (`font.body` 17pt) | `.accessibility3` |
| 캡션 메타 (`font.caption` 12pt) | `.accessibility2` |
| 하단 버튼 레이블 | `.accessibility1` — 버튼 너비 대응 |

`.accessibility3` 이상에서 하단 액션 바 레이블이 잘릴 경우 레이블 숨김 + SF Symbol만 표시:

```swift
@Environment(\.dynamicTypeSize) private var typeSize

var showButtonLabel: Bool { typeSize < .accessibility3 }
```

### 9.4 키보드 내비게이션 (iPad)

Tab 순서: 모드 전환 버튼 → 제목 필드 → 매체 picker → 제작자 필드 → 저장 버튼.

```swift
// 포커스 순서 명시
@FocusState private var focused: CaptureField?

enum CaptureField { case title, creator }

TextField("capture.field.title", text: $title)
    .focused($focused, equals: .title)
    .onSubmit { focused = .creator }
```

---

## 10. 로컬라이제이션 — i18n 문자열 키

ko/en/ja Wave 1 기준. 하드코딩된 사용자 표시 문자열 금지.

```
// 툴바
"capture.title" = "캡처";          // "Capture";       // "キャプチャ"
"capture.close" = "닫기";          // "Close";         // "閉じる"
"capture.save"  = "저장";          // "Save";          // "保存"

// 모드 버튼
"capture.mode.barcode" = "스캔";   // "Scan";          // "スキャン"
"capture.mode.voice"   = "음성";   // "Voice";         // "音声"
"capture.mode.manual"  = "수동";   // "Manual";        // "手動"

// 폼 필드
"capture.field.title"   = "제목";  // "Title";         // "タイトル"
"capture.field.creator" = "저자 / 아티스트 / 감독…";
                                    // "Author / Artist / Director…";
                                    // "著者 / アーティスト / 監督…"
"capture.field.medium"  = "매체";  // "Medium";        // "種別"

// 매체 옵션
"medium.book"   = "책";           // "Book";          // "本"
"medium.music"  = "음악";         // "Music";         // "音楽"
"medium.movie"  = "영화";         // "Movie";         // "映画"
"medium.object" = "물건";         // "Object";        // "もの"

// 상태 메시지
"capture.status.scanning"    = "바코드를 프레임 안에 위치시키세요";
"capture.status.recognizing" = "메타데이터 조회 중…";
"capture.status.recording"   = "녹음 중";

// 오류 배너
"capture.error.not_found"    = "메타데이터를 찾지 못했습니다. 직접 입력해주세요.";
"capture.error.offline"      = "오프라인 상태입니다. 직접 입력해주세요.";
"capture.error.camera_denied"= "카메라 접근 권한이 필요합니다.";
"capture.error.mic_denied"   = "마이크 접근 권한이 필요합니다.";
"capture.error.open_settings"= "설정 열기";

// 중복 감지
"capture.duplicate.title"   = "이미 컬렉션에 있습니다";
"capture.duplicate.add_memory" = "기억만 추가";
"capture.duplicate.add_new"    = "새로 추가";
```

---

## 11. 성능 예산

3초 캡처 약속(PRD Hero Moment 1)을 달성하기 위한 각 단계별 시간 상한:

| 단계 | 상한 | 측정 방법 |
|------|------|----------|
| 바코드 인식 (`AVCaptureMetadataOutput` 첫 콜백) | 500ms | Instruments → Core Animation |
| 메타데이터 조회 (네트워크 포함) | 1000ms | URLSession.dataTask duration |
| 음성 인식 (발화 종료 → 전사 결과) | 800ms | SFSpeechRecognitionTask timing |
| SwiftData 저장 (`modelContext.save()`) | 100ms | Instruments → File System |
| **캡처 시작 → 저장 완료 합계** | **3000ms** | XCTest `measure {}` |

오프라인 메타데이터 조회 실패는 즉각(`<50ms`) `manualFallback` 전환 — 네트워크 타임아웃 대기 금지. `URLSession.configuration.timeoutIntervalForRequest = 2.0` 상한.

---

## 12. 개인정보 처리

### 12.1 카메라 / 마이크 권한

`Info.plist` 필수 키 (이미 등록됨):

```xml
<key>NSCameraUsageDescription</key>
<string>바코드를 스캔해 자산을 3초 만에 등록합니다.</string>

<key>NSMicrophoneUsageDescription</key>
<string>음성으로 자산 제목과 첫 기억을 남깁니다.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>음성을 텍스트로 변환합니다. 처리는 기기 내에서만 이루어집니다.</string>
```

### 12.2 Speech 권한 요청 흐름

권한 요청은 Onboarding 마지막 단계에 집중 (UX R1, Design.MD §5.5). CaptureSheet 내에서 최초 요청 금지.

```swift
// 권한 상태 확인 (CaptureView 진입 시)
SFSpeechRecognizer.requestAuthorization { status in
    DispatchQueue.main.async {
        if status != .authorized {
            // permissionDenied 상태로 전환, 설정 유도
        }
    }
}
```

### 12.3 온디바이스 처리 강제

`SFSpeechAudioBufferRecognitionRequest.requiresOnDeviceRecognition = true`. 온디바이스 인식 불가 기기에서 실패 시 Mode C로 graceful degradation. 클라우드 STT 폴백 없음 — PRD §7.8 "사용자 식별 정보 비송신" 정합.

### 12.4 메타데이터 조회 익명성

`MetadataResolver`가 외부 API 호출 시 User-Agent에 기기 식별자 포함 금지. 요청 헤더: `User-Agent: StillHours/1.0`. 조회 실패 로그는 로컬 전용 — 외부 전송 없음.

---

## 13. 엣지 케이스

| 케이스 | 발생 조건 | 처리 |
|--------|----------|------|
| 프레임 내 복수 바코드 | 여러 상품이 동시에 인식됨 | 가장 큰 바코드 object 1개만 선택 (AVMetadataObject.bounds 기준) |
| 저조도 스캔 실패 | 어두운 환경에서 인식 불가 | 1500ms 내 인식 없으면 "조명이 부족합니다. 직접 입력해주세요." 배너 표시 → `manualFallback` |
| 마이크 권한 녹음 중 박탈 | 설정 앱에서 권한 해제 | `audioEngine` 에러 콜백 → 녹음 즉시 정지, `permissionDenied` 배너 표시 |
| 네트워크 오프라인 | 조회 중 연결 끊김 | 2초 타임아웃 후 `offlineMetadata` → Mode C. 로컬 저장(제목만)은 가능 |
| 중복 항목 | 동일 ISBN을 이미 보유 | `duplicateItem` alert: "이미 컬렉션에 있습니다 — 기억만 추가 / 새로 추가" |
| 시트 닫힘 (저장 전) | 사용자가 X 탭 또는 스와이프다운 | 입력 중인 데이터 폐기. 확인 alert 없음 — 3초 flow에서 alert는 마찰 |
| 카메라 세션 중단 | 전화 착신 등 인터럽트 | `AVCaptureSessionWasInterruptedNotification` 수신 → 세션 일시중지, 인터럽트 종료 시 자동 재개 |

---

## 14. 작업량 추정

DEVPLAN §5 Week 5 "CaptureFlow Book 22h" 기재 기준을 상세 spec 완성 후 재추정한다.

| 작업 | 예상 시간 | 비고 |
|------|----------|------|
| **Mode A — 바코드 스캔** | | |
| AVCaptureSession + 메타데이터 output 설정 | 4h | iOS 26 Simulator 바코드 테스트 복잡도 포함 |
| 뷰파인더 UI (L자 오버레이, 인식 상태 애니메이션) | 3h | |
| MetadataResolver 연동 (Open Library / MusicBrainz 조회) | 4h | Mock URLSession TDD 포함 |
| 인식 결과 미리보기 카드 + 편집 UI | 3h | |
| **소계 Mode A** | **14h** | |
| **Mode B — 음성 메모** | | |
| SFSpeechRecognizer 초기화 + 권한 흐름 | 3h | requiresOnDeviceRecognition 디버깅 |
| 파형 시각화 (오디오 레벨 연동 막대) | 4h | Reduced Motion 분기 포함 |
| 전사 결과 UI + 수정 가능 TextField | 2h | |
| **소계 Mode B** | **9h** | |
| **Mode C — 수동 입력** | | |
| 4-필드 폼 (TextField × 2 + Picker + PhotosPicker) | 4h | |
| MediaPicker (PhotosPicker + Camera 분기) | 3h | |
| **소계 Mode C** | **7h** | |
| **공통** | | |
| 상태 기계 `CaptureViewModel` + 분기 로직 | 4h | |
| Liquid Glass 툴바 + 하단 액션 바 | 3h | iOS 26 Xcode 실습 포함 |
| 엣지 케이스 처리 (중복, 오프라인, 저조도) | 3h | |
| 접근성 (VoiceOver + Reduced Motion + Dynamic Type) | 4h | |
| 로컬라이제이션 (ko/en/ja, 문자열 키 ~30개) | 3h | |
| XCTest integration (scan → save 전체 flow) | 4h | |
| **소계 공통** | **21h** | |
| **총합** | **51h** | |

DEVPLAN Week 5 배정 22h 대비 +29h (2.3×) 이유:
1. `AVCaptureSession` + `SFSpeechRecognizer` 복합 권한 흐름이 iOS 26 Simulator에서 별도 검증 필요.
2. MetadataResolver 외부 API 조회 mock + fallback chain이 예상보다 복잡 (Open Library → Google Books → 실패 3단계).
3. Liquid Glass 버튼 `.glassEffect(.regular.tint().interactive())` 는 iOS 26 신규 API — 실습 시간 포함.
4. 접근성: VoiceOver 동적 announcement (스캔 결과 발화) + Reduced Motion 분기 = 별도 패스 필요.

---

## 15. 미결 질문 (사용자 결정 필요 — Tier 1)

| # | 질문 | 선택지 | 영향 |
|---|------|--------|------|
| 1 | 클라우드 조회 제공사 | (a) Open Library + MusicBrainz + TMDB / (b) Google Books + Discogs + TMDB / (c) 혼합 fallback chain | MetadataResolver 구현 범위, 서드파티 약관 검토 |
| 2 | 음성 STT 품질 임계값 | (a) 신뢰도 0.7 이상만 자동 채움 / (b) 항상 사용자 확인 요구 / (c) 임계값 없이 최선 결과 제시 | Mode B UX flow, 오인식 빈도 |
| 3 | 수동 입력(Mode C) 최소 필드 | (a) 제목만 필수 (medium = Book 기본) / (b) 제목 + medium 필수 (현재 spec) / (c) 제목 + medium + creator 필수 | 등록 마찰, 빈 데이터 비율 |
| 4 | 저조도 스캔 실패 타임아웃 | (a) 1000ms / (b) 1500ms (현재 spec) / (c) 2000ms | Mode A → C 전환 빈도 |
| 5 | 새 디자인 토큰 필요 여부 | `capture.viewfinder.corner.color` (L자 오버레이 색 토큰) — 현재 `accent.default` 재사용 가능하나 semantic 분리 논의 필요 | Design.MD §3 토큰 추가 여부 |

---

_End of CaptureFlow-Design.md v1.0_

| Date | Change |
|------|--------|
| 2026-05-20 | v1.0 initial — PRD §9 Module 3 / Design.MD §5.5 / LiquidGlass-Notes.md / SFSymbols-Selection.md 전체 정합, 섹션 1-15 작성 |
