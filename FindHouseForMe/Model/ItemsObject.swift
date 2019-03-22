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


let itemRef = Database.database().reference().child("Items").childByAutoId()
let itemId = itemRef.key



class ItemObject {
    
    
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
    
    
    
    //    // 2
    //    ///////////////////////////////////////////////////
    //    //// Initializers
    //    ////////////////////////////////////////////////////
    init(TypeOfOffer : String? , TypeOfSelling : String?, Address : String?, NumberOfRoom : String? , Price : String?, Image : String?, ID : String? )
    {
        self.TypeOfOffer = TypeOfOffer
        self.TypeOfSelling = TypeOfSelling
        self.Address = Address
        self.NumberOfRoom = NumberOfRoom
        self.Price = Price
        self.Image = Image
        self.ID = ID
        
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

        
    }
    //
    //    ///////////////////////////////////////////////////
    //    //// Get Dictionary from the informations
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

        
        return newDictionary
    }
    //
    //
    //    ///////////////////////////////////////////////////
    //    //// Upload User Data To DataBase
    //    ////////////////////////////////////////////////////
    func Upload() {
        Database.database().reference().child("Items").childByAutoId().setValue(GetDictionary()) }
    
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


class ItemAPI {
    
    static func GetUser(ID : String , completion : @escaping (_ User : ItemObject?) ->()){
        
        if let CasheItem = Cashe2.ItemWith(ID: ID) {completion (CasheItem) ; return}

        Database.database().reference().child("Items").child(ID).observeSingleEvent(of: .value){ (Snapshot : DataSnapshot) in
            
            if Snapshot.exists() == false { completion(nil) ; return }
            
            guard let Userdictionary = Snapshot.value as? [String : AnyObject] else { completion(nil) ; return }
            
            let newUser = ItemObject(Dictionary: Userdictionary)
            completion(newUser)
            
            }
    }
        

    
    static func GetAllUsers (completion : @escaping (_ User : ItemObject?) ->()) {

        Database.database().reference().child("Items").observeSingleEvent(of: .value) { (DataSnapshot) in
            guard let Userdictionary = DataSnapshot.value as? [String : [String : AnyObject]] else { completion (nil) ; return }
            for one in Userdictionary.values {
                let user = ItemObject.init(Dictionary: one)
                completion(user)
            }
        }

    }


}


class Cashe2 {
    
    static var Items : [ItemObject] = []
    static func ItemWith(ID : String)->ItemObject? {
        for one in Items { if ID == one.ID {return one } }
        return nil }
    
}
