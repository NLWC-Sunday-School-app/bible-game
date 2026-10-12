import UIKit
import Firebase
import UserNotifications
import Flutter
import WidgetKit
import awesome_notifications
@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
override func application(
_ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
 FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self);
    SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
             SwiftAwesomeNotificationsPlugin.register(
               with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)

         }

    if let controller = window?.rootViewController as? FlutterViewController {
      registerVerseWidgetChannel(messenger: controller.binaryMessenger)
    }

         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}

  /// The verse widget cannot read the app's preferences, so the frequency the
  /// user picks is copied into the App Group both share, and the widget is
  /// asked to rebuild its timeline straight away.
  private func registerVerseWidgetChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "bible_game/verse_widget", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "setFrequency",
            let args = call.arguments as? [String: Any],
            let hours = args["hours"] as? Int
      else {
        result(FlutterMethodNotImplemented)
        return
      }
      UserDefaults(suiteName: "group.78RK4YBS4Q.com.nlwc.bible.game")?
        .set(hours, forKey: "verseFrequencyHours")
      if #available(iOS 14.0, *) {
        WidgetCenter.shared.reloadTimelines(ofKind: "VerseWidget")
      }
      result(nil)
    }
  }
}
