import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    // Note: GoogleService-Info.plist must be added to ios/Runner/ folder
    // If Firebase initialization fails, the app will still run but notifications won't work
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
      FirebaseApp.configure()
      print("[AppDelegate] ✅ Firebase configured successfully")
    } else {
      print("[AppDelegate] ⚠️ GoogleService-Info.plist not found. Firebase features will not work.")
      print("[AppDelegate] 💡 Please add GoogleService-Info.plist to ios/Runner/ folder")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Set notification delegate BEFORE requesting permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      // Request notification permissions
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { granted, error in
          if let error = error {
            print("[AppDelegate] ❌ Notification permission error: \(error.localizedDescription)")
          } else {
            print("[AppDelegate] ✅ Notification permission granted: \(granted)")
          }
        }
      )
    } else {
      // Fallback for iOS < 10.0 (not needed for iOS 13.0+)
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    // Register for remote notifications
    application.registerForRemoteNotifications()
    
    // Set FCM messaging delegate
    Messaging.messaging().delegate = self
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle successful APNS token registration
  override func application(_ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("[AppDelegate] ✅ APNS token registered")
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // Handle APNS token registration failure
  override func application(_ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("[AppDelegate] ❌ Failed to register for remote notifications: \(error.localizedDescription)")
  }
  
  // Handle notification received while app is in foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // Print notification data
    print("[AppDelegate] 📨 Foreground notification received:")
    print("[AppDelegate]   - Title: \(notification.request.content.title)")
    print("[AppDelegate]   - Body: \(notification.request.content.body)")
    print("[AppDelegate]   - UserInfo: \(userInfo)")
    
    // Show notification even when app is in foreground (iOS 14+)
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .badge, .sound]])
    } else {
      completionHandler([[.alert, .badge, .sound]])
    }
  }
  
  // Handle notification tap
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    print("[AppDelegate] 📬 Notification tapped:")
    print("[AppDelegate]   - Title: \(response.notification.request.content.title)")
    print("[AppDelegate]   - Body: \(response.notification.request.content.body)")
    print("[AppDelegate]   - UserInfo: \(userInfo)")
    
    completionHandler()
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  // Handle FCM token refresh
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("[AppDelegate] 🔑 FCM token: \(fcmToken ?? "nil")")
    
    // Send token to your server if needed
    // TODO: Implement token upload to your backend
  }
}
