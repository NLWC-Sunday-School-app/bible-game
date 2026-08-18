# VerseWidget — iOS Widget Extension Setup

The Swift code for the "Verse of the Hour" widget lives in this folder, but an
iOS **Widget Extension target** must be added once in Xcode (target creation +
signing can't be done from the command line). Takes ~5 minutes:

## 1. Add the Widget Extension target

1. Open `ios/Runner.xcworkspace` in Xcode.
2. **File → New → Target… → Widget Extension** (iOS tab).
3. Product Name: `VerseWidget`.
   - **Uncheck** "Include Live Activity" and "Include Configuration App Intent".
   - Embed in application: `Runner`.
4. Click **Finish**. When asked to activate the new scheme, click **Activate**.

## 2. Replace the generated code

1. In the new `VerseWidget` group Xcode created, delete the generated
   `VerseWidget.swift` (and `VerseWidgetBundle.swift` / assets it added,
   keep `Info.plist`) — choose **Move to Trash**.
2. Right-click the `VerseWidget` group → **Add Files to "Runner"…** and select
   `ios/VerseWidget/VerseWidget.swift` (this file). Ensure target membership
   is **VerseWidget** only.

## 3. Bundle the verses JSON

1. Again **Add Files to "Runner"…**, select
   `assets/data/memory_verses.json` from the project root.
   - **Uncheck "Copy items if needed"** (reference it in place, so app and
     widget always share one file).
   - Target membership: **VerseWidget** only.

## 4. Target settings

1. Select the `VerseWidget` target → **General**:
   - Minimum Deployment: **iOS 17.0** (the view uses `containerBackground`,
     an iOS 17 API; Runner already targets 17.4).
2. **Signing & Capabilities**: same team as Runner; bundle id should be
   `com.nlwc.bible.game.VerseWidget` (Xcode sets this automatically —
   adjust the prefix if Runner's bundle id differs).

## 5. Build

```
flutter build ios
```

Then on a device/simulator: long-press home screen → **+** → search
"Bible Game" → add **Verse of the Hour** (small or medium). For the lock
screen: long-press lock screen → Customize → add the widget to the
widgets area (rectangular or inline).

The verse rotates every hour using a pre-generated 24-entry WidgetKit
timeline — no background tasks or app launches needed.
