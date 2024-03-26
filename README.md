# Touchpaint Flutter

This is a simple Flutter app for latency testing and comparison to the [Touchpaint Linux kernel module](https://github.com/kdrag0n/touchpaint) and [native Android app](https://github.com/kdrag0n/touchpaint-android). Available modes include:

- Paint with finger (for testing drag latency)
- Fill screen on touch (for testing tap latency)
- Box follows touch (for testing drag latency differently, similar to this [Microsoft Research video](https://www.youtube.com/watch?v=vOvQCPLkPt4))
- Blank redraw (for testing baseline rendering performance)

Credits for version 1.0.0 go to [kdrag0n](https://github.com/kdrag0n) for the original code.

## Changelog

### 1.1.0
- Updated to Dart 3.0.0+
- Implemented null safety
- Bumped dependencies
- Updated iOS/Android support
- Added Linux, macOS support
- Added sample rate to "Follow" mode
- Minor fixes
