//
//  SignIn.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 4/22/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase

class SignIn: UIViewController {

    
    @IBOutlet weak var myPicker: UIPickerView!
    
    
    @IBOutlet weak var numberLabel: UITextField!
    
    @IBAction func signInButton(_ sender: UIButton) {
        print("Initiating authentication")
        
        PhoneAuthProvider.provider().verifyPhoneNumber( numberLabel.text!, uiDelegate: nil, completion: { (verificationId, error) in
            if error != nil{
                print("+++++++++++++++++++++@@@@@@@@@@@@@@@@")
                print(error!)
                return
            }
            
            UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
            print("Authentication called")
        })
        
        self.performSegue(withIdentifier: "goToVerity", sender: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "GoToHomePage1", sender: nil)
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
