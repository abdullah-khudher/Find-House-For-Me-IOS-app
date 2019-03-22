//
//  OfficeMainShow.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit

class OfficeMainShow: UIViewController {

    
    @IBAction func EditButton(_ sender: Any) {
        self.performSegue(withIdentifier: "EditButtonSegue", sender: nil)

    }
    
    @IBAction func AddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewButtonSegue", sender: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
