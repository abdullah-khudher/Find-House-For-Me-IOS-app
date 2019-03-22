//
//  LogIn.swift
//  TenMinutes
//
//  Created by Abdullah Jacksi on 2/19/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class OfficeLogIn: UIViewController {
    
    
    @IBOutlet weak var EnterEmail: UITextField!
    @IBOutlet weak var EnterPassword: UITextField!
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if (segue.identifier == "Anonymous") {
    //            let destVC : ShowCurrentUser = segue.destination as! ShowCurrentUser
    //            if let id = Auth.auth().currentUser?.uid {
    //                destVC.dataFromFirst = id
    //            }
    //        }
    //    }
    
    
    @IBAction func ButtonLogIn(_ sender: Any) {
        
        if let myEnterEmail = EnterEmail.text , let myEnterpassword = EnterPassword.text{
            Auth.auth().signIn(withEmail: (myEnterEmail), password: (myEnterpassword)) { (result, error) in
                if error != nil{
                    print("ERROR : \(String(describing: error)) ")
                }else{
                    print("yeah")
                    //                    if let myuid = Auth.auth().currentUser?.uid {
                    //                        let NewUser = UserObject(Name: "asd", Email: "shet", ID: myuid, SmallImageLink: "google.com/image1", BigImageLink: "google.com/image2", PhoneNumber: "34563", Lang: "arabic")
                    //                        //
                    //                        NewUser.Upload()
                    //                    }
                    self.performSegue(withIdentifier: "GoToHomePage1", sender: nil)
                }
            }
        }
    }
    
//    @IBAction func ButtonForgotPass(_ sender: Any) {
//        performSegue(withIdentifier: "Reset", sender: nil)
//    }
    
    
//    @IBAction func AsGuest(_ sender: Any) {
//        Auth.auth().signInAnonymously { (user, error) in
//            if error != nil {
//                print("Error : \(String(describing: error)) ")
//            }else{
//                // if there is no error we could handle it as we want
//                self.performSegue(withIdentifier: "Anonymous", sender: nil)
//                if let uid = user?.user.uid{
//                    print("UId of user : \(uid)")
//                }
//            }
//        }
//    }
    
    @IBAction func ButtonSignUp(_ sender: Any) {
        performSegue(withIdentifier: "ToSignUpPage", sender: nil)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "GoToHomePage1", sender: nil)
//        }
        
    }
    
    
    
    
}
