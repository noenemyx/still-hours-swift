# Medium Icons — SF Symbol Final Selection Brief

> v1.0 constraint: SF Symbol native only. Custom asset 금지.  
> 현재 선택 근거: `/tmp/curium-swift/docs/SFSymbols-Selection.md`

---

## 현재 선택 (v1.0 운용 중)

| Medium | Symbol | Variant |
|--------|--------|---------|
| 책 | `book.closed` | `.fill` |
| 음반 | `music.note` | regular |
| 영화 | `film` | `.fill` |
| 오브제 | `cube` | `.fill` |
| 장소 | `mappin.and.ellipse` | regular — **임시**, 검토 필요 |

---

## 디자이너 태스크

SF Symbols 7 (iOS 26) 카탈로그 기준으로 아래 표 완성:

```
| Medium | 최종 Symbol | Variant | Backup | 근거 (1줄) |
|--------|------------|---------|--------|-----------|
| 책     |            |         |        |           |
| 음반   |            |         |        |           |
| 영화   |            |         |        |           |
| 오브제 |            |         |        |           |
| 장소   |            |         |        |           |
```

16pt preview 캡처 첨부 권장 (SF Symbols macOS 앱).

---

## 제약

- iOS 26 (SF Symbols 7) 이상 가용 symbol만
- 5개 간 **visual weight 균형** — 16pt에서 선 두께/밀도 통일
- `accent.default` single tint. Multicolor 금지.
- 이모지 금지.

---

## Memory Kind와 의미 충돌 금지

아래 8개는 Memory Kind 전용. Medium symbol은 의미 계층 분리 필수.

| Kind | Symbol |
|------|--------|
| acquired | `shippingbox.fill` |
| read | `text.book.closed.fill` |
| listened | `headphones` |
| watched | `film.fill` |
| lent | `arrow.uturn.left` |
| received | `arrow.down.left.square.fill` |
| gifted | `gift.fill` |
| annotated | `pencil.line` |

`film.fill`은 watched kind와 동일 — context 분화 적용 중. 더 나은 대안 있으면 제안 가능.

---

## SF Symbols 7 업그레이드 후보

| 현재 | 후보 | 사유 |
|------|------|------|
| `film.fill` | `film.stack.fill` (SF 6+) | 컬렉션 느낌 |
| `cube.fill` | `cube.transparent` (SF 4+) | 유리/도자기 표현 |
| `music.note` | `music.note.list` | 앨범/트랙리스트 연상 |

---

## 사용 위치 (선택 symbol이 모든 위치에 동일 적용)

| 위치 | 크기 |
|------|------|
| SearchFirstView medium filter tab | 22pt |
| Library filter chip | 16pt |
| ItemCard medium badge | 12pt |
| Share Card placeholder | 48pt |

---

_참조_: `SFSymbols-Selection.md`, `04-BRAND-SUMMARY.md`, `00-CONTEXT.md`
