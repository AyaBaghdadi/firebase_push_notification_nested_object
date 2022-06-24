
# Technicalisto

## Handle Nested object get from Firebase Push Notification " Object inside object "

Note : 
       for easy understand firstly read this file ** once ** 
       & follow steps in new project from this [ReadMe](https://github.com/AyaBaghdadi/firebase_push_notification_nested_object) file or from this [Video]()
       Maybe you need to run in physical device ** Iphone ** so you need to create certificate with apple developer account , so you can watch this Playlist [Certificate for Apple Store-Firebase](https://www.youtube.com/watch?v=svkVOWdMVBA&list=PL4j2Hq_b76xKC3s6oDDEVdxBMYt54q6SL) , it's also useful for upload to apple store 
       If you need to Handle push notification but in Local ** Not ** from fire base with background tasks Watch this [Local Push Notification](https://youtu.be/dUTFQIUF0Rk)
   
       
## Let's Start 

1. Create Your Project In Firebase & Download google-service.plist & Add it in Your project Root.

   link of [Firebase](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwixxOCyo7T4AhULif0HHUPUBr8QFnoECA0QAQ&url=https%3A%2F%2Ffirebase.google.com%2F&usg=AOvVaw3fzCjfkgyYXdUPCdS8VWFg)

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

10. Connect with Account & Run & Try to send to iPhone from firebase with Fcm generated from Application ** Successfully

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

You can download from this link [Advanced Rest Client](https://install.advancedrestclient.com/install) 

Note : 
Add 
Url -> https://fcm.googleapis.com/fcm/send
content-type -> application/json
authorization -> key=Your_Key

This Test Object


```
{
"data":{
"priority":"high",
"body":"Push Notification Handle Model",
"sound":"default",
"title":"Technical Isto FCI",
"click_action":"MainActivity",
"id":"1",
"name" : "Try with Push Model",
"notificationType":"1" ,
"allDetails":
{
"detailsTxt":"Hello , we explain send firebase push notification with handle nested object and solve error decode",
"user":{"name":" Aya Baghdadi" , "phone":"+0200000000000" , "rate":5.0} ,
"address":{"details":"Cairo , Egypt" , "lat":30.564 , "lng":31.546}
}
},
"notification":{
"priority":"high",
"body":"Push Notification Handle Model",
"sound":"default",
"title":"Technical Isto FCI",
"click_action":"MainActivity"
},
"to":"your_fcm"
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
catch {
print(error)
}
dump(userInfo)

```

16. Add method HandleNotify Take ** Generic ** Model & ** completionHandler **

```
func HandleNotify(_ itemsCollection:PushModel.DataStruct, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){

var NewItem:PushModel.DataStruct! = PushModel.DataStruct()
NewItem = itemsCollection

itemsCollection.allDetails?.convertStringToObject(ModelData: PushModel.allDetails.self, success: { myData in
NewItem.allDetailsDecode = myData
dump(myData)
dump(NewItem)
print(NewItem.allDetailsDecode?.user?.name)
completionHandler([.alert,.badge, .sound])

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
