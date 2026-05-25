# Baseline Screenshots

Current-state UI reference for designer. Do NOT use as design target — use as "before" reference only.

**Captured**: 2026-05-26  
**Method**: `scripts/launch-sim.sh` — builds debug target, installs to iPhone 17 Pro simulator, injects real KOBIS + Naver API keys, launches with Korean locale + demo data.

## File Index

| File | Screen | Mode |
|------|--------|------|
| `01-curation-root-light.png` | Tab 1 큐레이션 (SearchFirstView) | Light |
| `02-curation-root-dark.png` | Tab 1 큐레이션 (SearchFirstView) | Dark |
| `03-library-light.png` | Tab 2 내 컬렉션 (LibraryView) | Light |
| `04-library-dark.png` | Tab 2 내 컬렉션 (LibraryView) | Dark |
| `05-settings-light.png` | Tab 3 설정 (SettingsView) | Light |
| `06-settings-dark.png` | Tab 3 설정 (SettingsView) | Dark |

## Known Limitations

- **Search results screen not captured** — requires automated Korean IME text input; not yet wired in capture script.
- **CardRenderView output not pre-rendered** — see `08-CARD-RENDER-SPEC.md` for exact pt dimensions and frame specs.
- Tab 2/3 navigation via `cliclick` coordinate tap on simulator window; if coordinates drift on display scale change, re-run with updated window position.
