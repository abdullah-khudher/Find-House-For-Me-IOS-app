//
//  UserObject.swift
//  KhalidPlusApp
//
//  Created by Osama Jassim on 10/3/17.
//  Copyright © 2017 Osama Jassim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase





class UserObject {
    
    
    // 1
    ///////////////////////////////////////////////////
    //// Variables
    ////////////////////////////////////////////////////
    var NumeOfOffice : String?
    var NumberOfOffice : String?
    var ID : String?
    
    
    // 2
    ///////////////////////////////////////////////////
    //// Initializers
    ////////////////////////////////////////////////////
    init(NumeOfOffice : String? , NumberOfOffice : String? , ID : String ) {
        self.NumeOfOffice = NumeOfOffice
        self.NumberOfOffice = NumberOfOffice
        self.ID = ID
        
    }
    
    init(Dictionary : [String : AnyObject])
    {
        self.ID = Dictionary["ID"] as? String
        self.NumeOfOffice = Dictionary["NumeOfOffice"] as? String
        self.NumberOfOffice = Dictionary["NumberOfOffice"] as? String
    }
    
    
    ///////////////////////////////////////////////////
    //// Get Dictionary from the informations
    ////////////////////////////////////////////////////
    func GetDictionary()-> [String : AnyObject] {
        var newDictionary : [String : AnyObject] = [:]
        newDictionary["NumeOfOffice"] = self.NumeOfOffice as AnyObject
        newDictionary["NumberOfOffice"] = self.NumberOfOffice as AnyObject
        newDictionary["ID"] = self.ID as AnyObject
        return newDictionary
    }
    
    
    ///////////////////////////////////////////////////
    //// Upload User Data To DataBase
    ////////////////////////////////////////////////////
    func Upload() { guard let id = self.ID else { return } ; Database.database().reference().child("Users").child(id).setValue(GetDictionary()) }
    
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


class UserAPI {
    
    static func GetUser(ID : String , completion : @escaping (_ User : UserObject?) ->()){
        
        if let CasheUser = Cashe.UserWith(ID: ID) {completion (CasheUser) ; return}
        
        Database.database().reference().child("Users").child(ID).observeSingleEvent(of: .value){ (Snapshot : DataSnapshot) in
            
            if Snapshot.exists() == false { completion(nil) ; return }
            
            guard let Userdictionary = Snapshot.value as? [String : AnyObject] else { completion(nil) ; return }
            
            let newUser = UserObject(Dictionary: Userdictionary)
            Cashe.Users.append(newUser)
            completion(newUser)
            
        }
        
    }
    
//    static func GetAllUsers (completion : @escaping (_ User : UserObject?) ->()) {
//
//        Database.database().reference().child("Users").observeSingleEvent(of: .value) { (DataSnapshot) in
//
//            guard let Userdictionary = DataSnapshot.value as? [String : [String : AnyObject]] else { completion (nil) ; return }
//
//            for one in Userdictionary.values {
//                let user = UserObject.init(Dictionary: one)
//                completion(user)
//            }
//        }
//
//    }
    
    static func CurrentUser(completion : @escaping (_ User : UserObject?)->()){
        _ = Auth.auth().addStateDidChangeListener() {(auth, user) in
            
            guard let UserID = user?.uid else { completion(nil) ; return }
            
            self.GetUser(ID :UserID, completion: { (User : UserObject?) in
                
                guard let CurrentUser = User else { completion(nil) ; return }
                
                completion(CurrentUser)
                
            })
        }
    }
}

class Cashe {
    
    static var Users : [UserObject] = []
    static func UserWith(ID : String)->UserObject? {
        for one in Users { if ID == one.ID {return one } }
        return nil }

}
