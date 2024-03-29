//
//  UserObject.swift
//  KhalidPlusApp
//
//  Created by Osama Jassim on 10/3/17.
//  Copyright © 2017 Osama Jassim. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON


var chickEditing : Bool = false

let itemRef = Database.database().reference().child("Items").childByAutoId()
let itemId = itemRef.key



class ItemObject{
    
    
    
    
    // 1
    ///////////////////////////////////////////////////
    //// Variables
    ////////////////////////////////////////////////////
    var TypeOfOffer : String?
    var TypeOfSelling : String?
    var Address : String?
    var NumberOfRoom : String?
    var Price : String?
    var Image : String?
    var ID : String?
    var itemId : String?
    var NumberOfBath : String?
    var HouseArea : String?
    
    
    //    // 2
    //    ///////////////////////////////////////////////////
    //    //// Initializers
    //    ////////////////////////////////////////////////////
    init(TypeOfOffer : String? , TypeOfSelling : String?, Address : String?, NumberOfRoom : String? , NumberOfBath : String?, HouseArea : String? , Price : String?, Image : String? , ID : String?, itemId : String? )
    {
        self.TypeOfOffer = TypeOfOffer
        self.TypeOfSelling = TypeOfSelling
        self.Address = Address
        self.NumberOfRoom = NumberOfRoom
        self.Price = Price
        self.Image = Image
        self.ID = ID
        self.itemId = itemId
        self.NumberOfBath = NumberOfBath
        self.HouseArea = HouseArea

        
    }
    
    
    init(Dictionary : [String : AnyObject])
    {
        self.TypeOfOffer = Dictionary["TypeOfOffer"] as? String
        self.TypeOfSelling = Dictionary["TypeOfSelling"] as? String
        self.Address = Dictionary["Address"] as? String
        self.NumberOfRoom = Dictionary["NumberOfRoom"] as? String
        self.Price = Dictionary["Price"] as? String
        self.Image = Dictionary["Image"] as? String
        self.ID = Dictionary["ID"] as? String
        self.itemId = Dictionary["itemId"] as? String
        self.NumberOfBath = Dictionary["NumberOfBath"] as? String
        self.HouseArea = Dictionary["HouseArea"] as? String



        
    }
    //
    //    ///////////////////////////////////////////////////
    //    //// Get Dictionary from the Firebase
    //    ////////////////////////////////////////////////////
    func GetDictionary()-> [String : AnyObject] {
        var newDictionary : [String : AnyObject] = [:]
        newDictionary["TypeOfOffer"] = self.TypeOfOffer as AnyObject
        newDictionary["TypeOfSelling"] = self.TypeOfSelling as AnyObject
        newDictionary["Address"] = self.Address as AnyObject
        newDictionary["NumberOfRoom"] = self.NumberOfRoom as AnyObject
        newDictionary["Price"] = self.Price as AnyObject
        newDictionary["Image"] = self.Image as AnyObject
        newDictionary["ID"] = self.ID as AnyObject
        newDictionary["itemId"] = self.itemId as AnyObject
        newDictionary["NumberOfBath"] = self.NumberOfBath as AnyObject
        newDictionary["HouseArea"] = self.HouseArea as AnyObject




        return newDictionary
    }
    //
    //
    //    ///////////////////////////////////////////////////
    //    //// Upload User Data To DataBase
    //    ////////////////////////////////////////////////////
    func Upload() {
        if chickEditing {
            Database.database().reference().child("Items").child(editingItemId!).setValue(GetDictionary())
        }else{
            itemRef.setValue(GetDictionary())
        }
        
        
    }
    
    
    /*
     
     
     
     */
    
    //
    //    ///////////////////////////////////////////////////
    //    //// Admin Banned or UNBanned
    //    ////////////////////////////////////////////////////
    //    func AdminOrderedBanned() { guard let id = self.ID else { return } ;  Database.database().reference().child("BannedUsers").child(id).setValue(true)
    //    }
    //
    //    func AdminOrderedUNBanned() { guard let id = self.ID else { return } ; Database.database().reference().child("BannedUsers").child(id).removeValue() }
    //
    
    
}
//    NumberOfBath
//    HouseArea

class ItemModel : Equatable {
  
    var TypeOfOffer : String?
    var TypeOfSelling : String?
    var Address : String?
    var NumberOfRoom : String?
    var Price : String?
    var Image : String?
    var ID : String?
    var itemId : String?
    var NumberOfBath : String?
    var HouseArea : String?
    

    init(TypeOfOffer : String? , TypeOfSelling : String?, Address : String? , NumberOfRoom : String? , NumberOfBath : String?, HouseArea : String? , Price : String?, Image : String?, ID : String?, itemId : String?  )
    {
        self.TypeOfOffer = TypeOfOffer
        self.TypeOfSelling = TypeOfSelling
        self.Address = Address
        self.NumberOfRoom = NumberOfRoom
        self.Price = Price
        self.Image = Image
        self.ID = ID
        self.itemId = itemId
        self.NumberOfBath = NumberOfBath
        self.HouseArea = HouseArea
    }
    
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        var isIt = true
        isIt = (lhs.TypeOfOffer == "" || lhs.TypeOfOffer == rhs.TypeOfOffer)
        && (lhs.TypeOfSelling == "" || lhs.TypeOfSelling == rhs.TypeOfSelling)
        && (lhs.Address == "" || lhs.Address == rhs.Address)
        && (lhs.NumberOfRoom == "" || lhs.NumberOfRoom == rhs.NumberOfRoom)
        && (lhs.Price == "" || lhs.Price == rhs.Price)
        && (lhs.NumberOfBath == "" || lhs.NumberOfBath == rhs.NumberOfBath)
        && (lhs.HouseArea == "" || lhs.HouseArea == rhs.HouseArea)


        return isIt
    }



}












class ItemAPI {

    static func GetItem(ID : String , completion : @escaping (_ User : ItemObject?) ->()){

        if let CasheItem = Cashe2.ItemWith(ID: ID) {completion (CasheItem) ; return}

        Database.database().reference().child("Items").child(ID).observeSingleEvent(of: .value){ (Snapshot : DataSnapshot) in

            if Snapshot.exists() == false { completion(nil) ; return }

            guard let Userdictionary = Snapshot.value as? [String : AnyObject] else { completion(nil) ; return }

            let newUser = ItemObject(Dictionary: Userdictionary)
            completion(newUser)

            }
    }



    static func GetAllItems (completion : @escaping (_ User : ItemObject?) ->()) {

        Database.database().reference().child("Items").observeSingleEvent(of: .value) { (DataSnapshot) in
            guard let Userdictionary = DataSnapshot.value as? [String : [String : AnyObject]] else { completion (nil) ; return }
            for one in Userdictionary.values {
                let user = ItemObject.init(Dictionary: one)
                completion(user)
            }
        }

    }

    static func CurrentItem(completion : @escaping (_ User : ItemObject?)->()){
        _ = Auth.auth().addStateDidChangeListener() {(auth, user) in

            guard let UserID = user?.uid else { completion(nil) ; return }

            self.GetItem(ID :UserID, completion: { (User : ItemObject?) in

                guard let CurrentUser = User else { completion(nil) ; return }

                completion(CurrentUser)

            })
        }
    }


}


class Cashe2 {

    static var Items : [ItemObject] = []
    static func ItemWith(ID : String)->ItemObject? {
        for one in Items { if ID == one.ID {return one } }
        return nil }

}

