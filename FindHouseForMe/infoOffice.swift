//
//  infoOffice.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 4/22/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase

class infoOffice: UIViewController {

    
    @IBOutlet weak var nameFiled: UITextField!
    
    @IBOutlet weak var numberFiled: UITextField!
    
    
    
    @IBAction func enterInfo(_ sender: UIButton) {
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let newUser = UserObject.init(NumeOfOffice: self.nameFiled.text, NumberOfOffice: self.numberFiled.text, ID: myUID)
            
            newUser.Upload()
            self.performSegue(withIdentifier: "goHomePage", sender: nil)

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        
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
