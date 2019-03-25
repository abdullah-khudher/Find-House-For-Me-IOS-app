//
//  OfficeSignUp.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 3/22/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase

class OfficeSignUp: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var nameOfficeTextField: UITextField!
    @IBOutlet weak var numberOfficeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if passwordTextField.text != repasswordTextField.text {
            print(" Error : must write your password correctly in Re-passowrd text ")
            return
        }
        if let myEnterEmail = emailTextField.text , let myEnterpassword = passwordTextField.text{
            Auth.auth().createUser(withEmail: (myEnterEmail), password: (myEnterpassword)) { (auth, error) in
                if error != nil {
                    //something bad happning
                    print("ERROR : \(String(describing: error)) ")
                }else{
//                    user registered successfully
                    if let myUID = Auth.auth().currentUser?.uid {
                        
                        let newUser = UserObject.init(NumeOfOffice: self.nameOfficeTextField.text, NumberOfOffice: self.numberOfficeTextField.text, ID: myUID)
                        
                        newUser.Upload()
                        
                    }
                    
                    self.performSegue(withIdentifier: "GoToHomePage2", sender: nil)
                }
            }
        }
    }
        
        
        
        
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
