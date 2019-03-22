//
//  SignUp.swift
//  TenMinutes
//
//  Created by Abdullah Jacksi on 2/19/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase

class OfficeSignUp: UIViewController {
    
    @IBOutlet weak var EnterEmail: UITextField!
    @IBOutlet weak var EnterPassword: UITextField!
    @IBOutlet weak var re_password: UITextField!
    @IBOutlet weak var nameOfOffice: UITextField!
    @IBOutlet weak var numberOfOffice: UITextField!
    
    @IBAction func ButtonSignUp(_ sender: Any) {
        
        if EnterPassword.text != re_password.text {
            print(" Error : must write your password correctly in Re-passowrd text ")
            return
        }
        
        
        
        if let myEnterEmail = EnterEmail.text , let myEnterpassword = EnterPassword.text{
            Auth.auth().createUser(withEmail: (myEnterEmail), password: (myEnterpassword)) { (auth, error) in
                if error != nil {
                    //something bad happning
                    print("ERROR : \(String(describing: error)) ")
                }else{
                    //user registered successfully
                    if let myuid = Auth.auth().currentUser?.uid {
                        
                        let newUser = UserObject(NumeOfOffice: self.nameOfOffice.text, NumberOfOffice: self.numberOfOffice.text, ID: myuid)
                        newUser.Upload()
                    }
                    self.performSegue(withIdentifier: "GoToHomePage1", sender: nil)
                }
            }
        }
    }
    
//    if nameOfOffice.text == nil || numberOfOffice.text == nil {
//    let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of offer ", preferredStyle: UIAlertController.Style.alert)
//    alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
//    self.present(alert, animated: true, completion: nil)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Osama")
        
    }
    
    
    
    

    
}
