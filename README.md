
# Technicalisto

## Handle Nested object get from Firebase Push Notification " Object inside object "

1. Create Your Project In Firebase & Download google-service.plist & Add it in Your project Root.

2. In Project go to Targets -> Signing & Capabilities -> Click Plus Button -> Enable :

```
* Push Notitfication

* Background Modes & Check : [ Background fetch , Remote Notification ]
```

3. Create Pod file & instal this 3 pods 

```
pod 'Firebase/Core'

pod 'Firebase/Messaging'

pod 'FirebaseInstanceID'
  
```

4. In App delegate & import this 2 library

```
import UserNotifications

import Firebase

```

5. In App delegate in method ** didFinishLaunchingWithOptions ** configure firebase by writing the following :

```

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
        
```

6. Define gcmMessageIDKey as to use in the following added methods 

```
let gcmMessageIDKey = "gcm.message_id"

```
7. In App delegate file add additional ** 4 ** method with implement

```
// 1
// [ START receive_message ]
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
if let messageID = userInfo[gcmMessageIDKey] {
print("Message ID: \(messageID)")
}
print(userInfo)
}
 
 ```
 
 ```   
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
```

```
// 3
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
print("Unable to register for remote notifications: \(error.localizedDescription)")
}

```

```
// 4
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
print("APNs token retrieved: \(deviceToken)")
Messaging.messaging().apnsToken = deviceToken
Messaging.messaging().setAPNSToken(deviceToken as Data, type: .unknown)
}
     
```

8. Add Extension for AppDelegate inhirit ** UNUserNotificationCenterDelegate ** with Methods userNotificationCenter 

```
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
// Receive displayed notifications for iOS 10 devices.
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
let userInfo = notification.request.content.userInfo
if let messageID = userInfo[gcmMessageIDKey] {
print("Message ID: \(messageID)")
}
 
completionHandler([.alert,.badge, .sound])
}
    
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
 withCompletionHandler completionHandler: @escaping () -> Void) {
 let userInfo = response.notification.request.content.userInfo

print(userInfo)
        
completionHandler()
}
    
}

```

9. Add Extension for AppDelegate inhirit ** MessagingDelegate ** with Methods messaging

```
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcm_token")
        let dataDict:[String: String] = ["token": fcmToken]
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")

    }
    
}

```

10. Run & Try to send to iPhone from firebase with Fcm generated from Application ** Successfully

11. Add Extenstion for UIApplication with function topViewController to get ** Top View Controller 

```

extension UIApplication {

class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
if let navigationController = controller as? UINavigationController {
return topViewController(controller: navigationController.visibleViewController)
}
if let tabController = controller as? UITabBarController {
if let selected = tabController.selectedViewController {
return topViewController(controller: selected)
}
}
if let presented = controller?.presentedViewController {
return topViewController(controller: presented)
}
return controller
}   
}

```

Note : if You want to call this method :

```
if let topController = UIApplication.topViewController() {
}
```

12. Add Push Notification Created Custom ** Model

13. To Test Download ** Advanced Rest Client ** App or any similar App 

14. Update Method to decode Nested Object ** Strings ** With method added in Model file.

### Thanks

This app is inspired by Aya Baghdadi”
and copyright for [@Technicalisto](https://www.youtube.com/channel/UC7554uvArdSxL4tlws7Wf8Q)
