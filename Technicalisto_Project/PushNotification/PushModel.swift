//-------------------------------------
  /// We make Class [ PushModel ]
//-------------------------------------
import UIKit

class PushModel {
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
