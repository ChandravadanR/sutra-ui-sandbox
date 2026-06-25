# Sutra UI Sandbox

A **standalone, frontend-only** Flutter project for redesigning three UI pieces of
the Sutra app. It contains **no backend, no Rust, no real chat/payments/EdTech
code** — only the screens being reworked, plus the theme and mock data needed to
run them. All data is hard-coded mock data.

## What to redesign (the 3 files)

| # | File | Task |
|---|------|------|
| 1 | `lib/src/shared/widgets/sutra_nav_bar.dart` | Redesign the bottom navigation bar. |
| 2 | `lib/src/features/home/presentation/screens/home_landing_screen.dart` | Home screen. Rework the **message entry point** in the app bar. |
| 3 | `lib/src/features/messages/message_drawer.dart` | **New** top pull-down drawer holding the **Personal / Business** tabs + message lists. |

The message flow: the chat-bubble icon in the home app bar opens the pull-down
`MessageDrawer`. The drawer is a minimal working starting point — redesign the
pull-down mechanism (e.g. drag-to-open), tabs, and row styling freely.

## What is intentionally NOT here (out of scope)

- The actual **messaging / conversation window** — unchanged, not included. Tapping
  a chat row just shows a snackbar.
- The six home **content strips** (Continue learning, Trending courses, etc.) —
  shown as grey `PlaceholderStrip` boxes. Do not redesign these.
- The other nav tabs (Store/Explore/Status/Calls/Settings) — placeholders.

## How to run

```bash
flutter pub get
flutter run -d windows     # or: flutter run -d chrome   /   flutter run (Android)
```

Use the theme tokens, never hard-coded values:
- Colors: `context.sutraColors` (e.g. `context.sutraColors.primary`)
- Type:   `context.sutraTypography`
- Shapes: `context.sutraShapes`

## Files you should NOT need to edit (support scaffolding)

- `lib/main.dart` + `_SandboxShell` — sandbox app shell (the real app uses a routed
  shell; this is just enough to host the nav bar + home).
- `lib/src/core/theme/*` — the real Sutra theme tokens (copied as-is). `theme_provider.dart`
  is a trimmed sandbox build of the theme.
- `lib/src/shared/widgets/liquid_glass_container.dart` — glass surface (sandbox stub).
- `lib/src/sandbox/*` — mock chat data + placeholder strip.

## Handoff back to the maintainers

When done, send back the **3 redesigned files** (plus any small new helper files
you add). They drop straight into the real app — the package name and folder
paths here match the real project, so the redesigned `sutra_nav_bar.dart`,
`home_landing_screen.dart`, and `message_drawer.dart` integrate with minimal
rewiring (the real app reconnects them to GoRouter routes and live data).
