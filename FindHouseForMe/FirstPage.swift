//
//  FirstPage.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/6/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class FirstPage: UIViewController {

    
    @IBAction func Lookingfor(_ sender: UIButton) {
        self.performSegue(withIdentifier: "asAGuest", sender: nil)
    }
    
    @IBAction func HavingAnOffice(_ sender: UIButton) {
        self.performSegue(withIdentifier: "asAnOffice", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if Auth.auth().currentUser != nil {
//            do{
//                try Auth.auth().signOut()
//            }
//            catch let error{
//                print(error)
//            }
//        }
}
    


}
