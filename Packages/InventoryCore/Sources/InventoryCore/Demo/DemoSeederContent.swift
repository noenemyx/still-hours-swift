// DemoSeederContent.swift — InventoryCore/Demo
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.7
// Created: 2026-05-21
// LINT-IGNORE: Privacy — no external URL

#if DEBUG

import Foundation

// MARK: - Supporting Types

/// A single demo item descriptor (data only, no logic).
struct DemoItem {
    let title: String
    let creator: String?
    let year: Int
    let medium: Medium
    let state: ItemState
    let tags: [String]
    let memories: [DemoMemory]
}

/// A single demo memory descriptor relative to the current date.
struct DemoMemory {
    let kind: MemoryKind
    let note: String
    /// Days before now when this memory occurred.
    let daysAgo: Int
}

// MARK: - Curated Content

/// Static, culturally-curated seed content for the demo library.
///
/// All references are factual (titles, creators, years) and do not
/// include cover image URLs or proprietary artwork — Demo-only, no
/// trademark concerns.
enum DemoSeederContent {

    // MARK: Books

    static let books: [DemoItem] = [
        DemoItem(
            title: "Norwegian Wood",
            creator: "Haruki Murakami",
            year: 1987,
            medium: .book,
            state: .owned,
            tags: ["소설", "일본", "무라카미"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "도쿄 다이칸야마 츠타야에서 발견. 표지 색이 너무 좋아서 그냥 집어 들었다.",
                    daysAgo: 420
                ),
                DemoMemory(
                    kind: .read,
                    note: "두 번째 완독. 처음과 완전히 다른 책처럼 읽혔다 — 나이가 든 탓인지.",
                    daysAgo: 180
                ),
                DemoMemory(
                    kind: .annotated,
                    note: "\"죽음은 삶의 대극에 있는 게 아니라 삶 속에 잠재해 있다.\" 밑줄 세 번.",
                    daysAgo: 178
                ),
            ]
        ),
        DemoItem(
            title: "The Hard Thing About Hard Things",
            creator: "Ben Horowitz",
            year: 2014,
            medium: .book,
            state: .owned,
            tags: ["경영", "스타트업", "leadership"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "어머니에게 받은 책. 표지를 보고 처음엔 거부감이 있었는데.",
                    daysAgo: 390
                ),
                DemoMemory(
                    kind: .read,
                    note: "Struggle 챕터 — 창업자가 아니어도 울림이 있다. 독서 모임에서 발표 자료로 썼다.",
                    daysAgo: 200
                ),
            ]
        ),
        DemoItem(
            title: "Invisible Cities",
            creator: "Italo Calvino",
            year: 1972,
            medium: .book,
            state: .owned,
            tags: ["소설", "이탈리아", "문학"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "홍대 앞 독립 서점에서. 번역본과 영문판 둘 다 샀는데 영문판이 훨씬 리드미컬하다.",
                    daysAgo: 310
                ),
                DemoMemory(
                    kind: .read,
                    note: "출장 기간 중 호텔 방에서 읽었다. 도시마다 이름을 붙이고 싶어졌다.",
                    daysAgo: 95
                ),
            ]
        ),
    ]

    // MARK: Music

    static let music: [DemoItem] = [
        DemoItem(
            title: "Kind of Blue",
            creator: "Miles Davis",
            year: 1959,
            medium: .music,
            state: .owned,
            tags: ["재즈", "classic", "vinyl"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "황학동 레코드 가게에서 오리지널 Columbia 프레스 발견. 재킷 상태 A-.",
                    daysAgo: 500
                ),
                DemoMemory(
                    kind: .listened,
                    note: "처음 들었던 곳: 을지로 카페 두레. So What 인트로에서 멈추게 됐다.",
                    daysAgo: 490
                ),
                DemoMemory(
                    kind: .listened,
                    note: "비 오는 금요일 오후, 사무실 혼자 남아서. 이 앨범은 계절을 안 탄다.",
                    daysAgo: 60
                ),
            ]
        ),
        DemoItem(
            title: "In Rainbows",
            creator: "Radiohead",
            year: 2007,
            medium: .music,
            state: .owned,
            tags: ["록", "UK", "얼터너티브"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "15 Step 첫 드럼 루프에 반해서 LP 주문. 두꺼운 패키지 언박싱이 의식처럼 느껴졌다.",
                    daysAgo: 270
                ),
                DemoMemory(
                    kind: .listened,
                    note: "Nude 를 새벽 2시에 — 볼륨 낮추고 headphone. 이 사운드는 어디서 만들었을까.",
                    daysAgo: 45
                ),
            ]
        ),
    ]

    // MARK: Movies

    static let movies: [DemoItem] = [
        DemoItem(
            title: "Lost in Translation",
            creator: "Sofia Coppola",
            year: 2003,
            medium: .movie,
            state: .owned,
            tags: ["드라마", "도쿄", "미국", "Criterion"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "Criterion Collection Blu-ray. 유리 케이스가 차갑고 무겁다.",
                    daysAgo: 365
                ),
                DemoMemory(
                    kind: .watched,
                    note: "도쿄 출장 전날 밤 다시 봤다. 파크 하얏트 바 장면에서 기시감이 왔다.",
                    daysAgo: 100
                ),
            ]
        ),
        DemoItem(
            title: "Spirited Away",
            creator: "Hayao Miyazaki",
            year: 2001,
            medium: .movie,
            state: .owned,
            tags: ["애니메이션", "지브리", "일본", "판타지"],
            memories: [
                DemoMemory(
                    kind: .watched,
                    note: "劇場版で初めて見た — 어릴 때는 이해 못 했던 장면들이 지금은 너무 선명하다.",
                    daysAgo: 530
                ),
                DemoMemory(
                    kind: .watched,
                    note: "조카에게 보여주다가 내가 더 울었다. 부모님 생각.",
                    daysAgo: 12
                ),
            ]
        ),
    ]

    // MARK: Places

    static let places: [DemoItem] = [
        DemoItem(
            title: "도쿄 츠타야",
            creator: nil,
            year: 1983,
            medium: .place,
            state: .owned,
            tags: ["서점", "도쿄", "일본"],
            memories: [
                DemoMemory(
                    kind: .visited,
                    note: "어머니와 함께. 시즈오카 다녀오는 길에.",
                    daysAgo: 647
                ),
            ]
        ),
    ]

    // MARK: Objects

    static let objects: [DemoItem] = [
        DemoItem(
            title: "Leica M6",
            creator: "Leica Camera AG",
            year: 1984,
            medium: .object,
            state: .owned,
            tags: ["카메라", "필름", "독일", "빈티지"],
            memories: [
                DemoMemory(
                    kind: .acquired,
                    note: "광화문 중고 카메라 상가에서. 전 주인이 한 롤만 쐈다는데 셔터 감이 믿기지 않게 살아있었다.",
                    daysAgo: 450
                ),
                DemoMemory(
                    kind: .annotated,
                    note: "첫 롤: Kodak Ultramax 400. 광화문 골목 + 경복궁 돌담. 5장 건졌다.",
                    daysAgo: 440
                ),
                DemoMemory(
                    kind: .lent,
                    note: "친구 결혼식 촬영용으로 빌려줬다. 필름 카메라 결혼 사진이라니.",
                    daysAgo: 120
                ),
            ]
        ),
    ]
}

#endif
