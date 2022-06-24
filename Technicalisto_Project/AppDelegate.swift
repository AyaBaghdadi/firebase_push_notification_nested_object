//
//  Created by Technicalisto.
//

import UIKit
import UserNotifications
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Start For Push Notification
        FirebaseApp.configure()
                
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
                    
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
        } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        }
                
        application.registerForRemoteNotifications()
        // End Push Notification
        
        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    // 1
    // [ START receive_message ]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    if let messageID = userInfo[gcmMessageIDKey] {
    print("Message ID: \(messageID)")
    }
    print(userInfo)
    }
     
    // 2
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if let messageID = userInfo[gcmMessageIDKey] {
    print("Message ID: \(messageID)")
    }
    print(userInfo)
    completionHandler(UIBackgroundFetchResult.newData)
    }
    // [ END receive_message ]
    
    // 3
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // 4
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")
    Messaging.messaging().apnsToken = deviceToken
    Messaging.messaging().setAPNSToken(deviceToken as Data, type: .unknown)
    }
         


}

