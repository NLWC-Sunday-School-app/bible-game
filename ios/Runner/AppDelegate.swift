import UIKit
import Firebase
import UserNotifications
import Flutter
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

         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
}
