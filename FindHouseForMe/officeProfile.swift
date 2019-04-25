//
//  officeProfile.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 4/23/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase

class officeProfile: UIViewController {
    
    let user = UserAPI.self
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    
    @IBAction func editButton(_ sender: UIButton) {
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let newUser = UserObject.init(NumeOfOffice: self.nameField.text, NumberOfOffice: self.numberField.text, ID: myUID)
            
            newUser.Upload()
            
        }
        
    }
    

    @IBAction func signOutButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goFirstPage", sender: nil)
        if Auth.auth().currentUser != nil {
            do{
                try Auth.auth().signOut()
            }
            catch let error{
                print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.hideKeyboardWhenTappedAround()

        
        // Do any additional setup after loading the view.
        user.CurrentUser { (user) in
            self.nameField.text = user?.NumeOfOffice
            self.numberField.text = user?.NumberOfOffice
        }
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
