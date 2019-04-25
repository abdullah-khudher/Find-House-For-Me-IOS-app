//
//  VerifyCode.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 4/22/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase

class VerifyCode: UIViewController {

    
    @IBOutlet weak var verifyField: UITextField!
    
    @IBAction func enterCode(_ sender: UIButton) {
        
        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID"){
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verifyField.text!);
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                print(user!)
            })
        }
        self.performSegue(withIdentifier: "goToCreateProfile", sender: nil)

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
