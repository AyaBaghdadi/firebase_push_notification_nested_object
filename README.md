
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

Example Model 

```
//-------------------------------------
  /// We make Class [ PushModel ]
//-------------------------------------
import UIKit
class PushModel: MainModel {
  // This Get From data object not notification object
  // notification object only get for Title & Body
 struct DataStruct: Decodable {
   var id:String?
   var name:String?
   var notificationType:String?
   var allDetails:String?
   var allDetailsDecode:allDetails?
 }
 struct allDetails:Decodable {
   var detailsTxt:String?
   var user:user?
   var address:address?
 }
  struct user:Decodable {
    var phone:String?
    var rate:Double?
    var name:String?
  }
  struct address:Decodable {
    var details:String?
    var lat:Double?
    var lng:Double?
  }
}
extension String {
  func toJSON() -> Any? {
    guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  }
  func convertStringToObject<TD:Decodable>(ModelData:TD.Type , success: @escaping ((_ myData:TD?) ->())){
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(self) {
      if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
      }
    }
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self.toJSON() as Any)
      let itemsCollection = try JSONDecoder().decode(ModelData.self, from: jsonData)
      success(itemsCollection)
    }
    catch {
    print(error)
    }
  }
}

```

13. To Test Download ** Advanced Rest Client ** App or any similar App 

This Test Object


```

{
“data”:{
“priority”:“high”,
“body”:“Push Notification Handle Model”,
“sound”:“default”,
“title”:“Technical Isto FCI”,
“click_action”:“MainActivity”,
“id”:“1”,
“name” : “Try with Push Model”,
“notificationType”:“1” ,
“allDetails”:
{
“detailsTxt”:“Hello , we explain send firebase push notification with handle nested object and solve error decode”,
“user”:{“name”:” Aya Baghdadi” , “phone”:“+0200000000000” , “rate”:5.0} ,
“address”:{“details”:“Cairo , Egypt” , “lat”:30.564 , “lng”:31.546}
}
},
“notification”:{
“priority”:“high”,
“body”:“Push Notification Handle Model”,
“sound”:“default”,
“title”:“Technical Isto FCI”,
“click_action”:“MainActivity”
},
“to”:“your_fcm”
}

```

14. Update Method to decode Nested Object ** Strings ** With method added in Model file.

15. In get of userInfo Handle By :

Using method added in Push Model

```

let userInfo = response.notification.request.content.userInfo

do {
let jsonData = try JSONSerialization.data(withJSONObject: userInfo)
let itemsCollection = try JSONDecoder().decode(PushModel.DataStruct.self, from: jsonData)
  
 ///  ** Handle Here      

print(itemsCollection)
}
atch {
print(error)
}
dump(userInfo)

```

16. Add method HandleNotify Take ** Generic ** Model & ** completionHandler **

```
func HandleNotify(_ itemsCollection:PushModel.DataStruct, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){

var NewItem:PushModel.DataStruct! = PushModel.DataStruct()
NewItem = itemsCollection

itemsCollection.details?.convertStringToObject(ModelData: PushModel.details.self, success: { myData in
NewItem.detailsDecode = myData
dump(myData)
dump(NewItem)
})

```

17. Call method HandleNotify inside get of itemsCollection With : 

```
HandleNotify(itemsCollection) { UNNotificationPresentationOptions in
            
}

```

### Thanks

This app is inspired by Aya Baghdadi”
and copyright for [@Technicalisto](https://www.youtube.com/channel/UC7554uvArdSxL4tlws7Wf8Q)
