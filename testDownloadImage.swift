//
//  testDownloadImage.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 3/26/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SDWebImage

class testDownloadImage: UIViewController {

    
    @IBOutlet weak var imageview: UIImageView!
    
    var arrayItems3 = [ItemModel]()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        myMethod { (items) in
            self.arrayItems3.append(contentsOf: items)
            
            print("============ closure ==========")
            print(self.arrayItems3.count)
            
            
        }
        
        
        print("============  did load ==========")
        print(arrayItems3.count)
        

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        print("============  did appear ==========")
        print(arrayItems3.count)
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {

        print("============  will appear ==========")
        print(arrayItems3.count)
        
//        let url = URL(string: arrayItems2[0].Image!)
//        self.imageview.sd_setImage(with: url, placeholderImage: nil)

        
    
    }
    
    
    
    
    func myMethod (seccuess:@escaping ([ItemModel])->Void){
        
        
        
        Database.database().reference().child("Items").observe(DataEventType.value, with: { (snapshot) in
            
            var arrayItems2 = [ItemModel]()
            
            for Items in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let itemObject = Items.value as? [String: AnyObject]
                
                let TypeOfOffer  = itemObject?["TypeOfOffer"]
                let TypeOfSelling  = itemObject?["TypeOfSelling"]
                let Address = itemObject?["Address"]
                let NumberOfRoom = itemObject?["NumberOfRoom"]
                let Price = itemObject?["Price"]
                let Image = itemObject?["Image"]
                let ID = itemObject?["ID"]
                let itemId = itemObject?["itemId"]
                
                
                
                //creating artist object with model and fetched values
                let item = ItemModel(TypeOfOffer: TypeOfOffer as! String?, TypeOfSelling: TypeOfSelling as! String?, Address: Address as! String?, NumberOfRoom: NumberOfRoom as! String?, Price: Price as! String?, Image: Image as! String?, ID: ID as! String?, itemId:itemId as! String? )
                
                
                arrayItems2.insert(item, at: 0)
                
                
            }
            
            //                            if arrayItems2.count != 0 {
            //                                let url = URL(string: arrayItems2[0].Image!)
            //                                self.imageview.sd_setImage(with: url, placeholderImage: nil)
            //                            }
            //                else{
            //                    let url = URL(string: "https://www.gstatic.com/webp/gallery3/2_webp_ll.png")
            //                    self.imageview.kf.setImage(with: url)
            //                }
            
            seccuess(arrayItems2)
            
        })
        
        
        
        
        
    }
    
    
    
    
    
        
        
    
        
        
        
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func butt(_ sender: UIButton) {
    
        
        
//        let url = URL(string: "https://images.all-free-download.com/images/graphiclarge/beautiful_natural_scenery_04_hd_pictures_166229.jpg")
//        self.imageview.kf.setImage(with: url)
        
        
//
//        let url = URL(string: "https://www.gstatic.com/webp/gallery3/2_webp_ll.png")
//        self.imageview.sd_setImage(with: url, placeholderImage: nil)
//        
//
//        print("count2   ++++++++++++++++===================")
////
////        print(arrayItems2.count)
    
    
    }
    
    
    
    
  
    
    
    
    
    
    
    
    

}




