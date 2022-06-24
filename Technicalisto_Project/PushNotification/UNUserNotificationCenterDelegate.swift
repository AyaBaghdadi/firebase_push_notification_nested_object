
import Foundation
import UIKit

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
// Receive displayed notifications for iOS 10 devices.
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
let userInfo = notification.request.content.userInfo
if let messageID = userInfo[gcmMessageIDKey] {
print("Message ID: \(messageID)")
}

dump(userInfo)
   
    
    
    
completionHandler([.alert,.badge, .sound])
}
    
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
 withCompletionHandler completionHandler: @escaping () -> Void) {
    
    
    let userInfo = response.notification.request.content.userInfo

    do {
    let jsonData = try JSONSerialization.data(withJSONObject: userInfo)
    let itemsCollection = try JSONDecoder().decode(PushModel.DataStruct.self, from: jsonData)
      
     ///  ** Handle Here

    print(itemsCollection)
        
        HandleNotify(itemsCollection) { UNNotificationPresentationOptions in

        }

    }
    catch {
    print(error)
    }
    dump(userInfo)

    
        
completionHandler()
}
    
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

}
}
