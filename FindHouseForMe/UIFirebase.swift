//
//  UIFirebase.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 4/22/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class UIFirebase: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FUIAuth.defaultAuthUI()?.delegate = self as! FUIAuthDelegate
        let phoneProvider = FUIPhoneAuth.init(authUI: FUIAuth.defaultAuthUI()!)
        FUIAuth.defaultAuthUI()?.providers = [phoneProvider]
        
        
        // Swift
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: currentlyVisibleController, phoneNumber: nil)
    }
    
    // Swift

    
    /* ... */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
