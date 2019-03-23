//
//  OfficeAddNew.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class OfficeAddNew: UIViewController {
    
    
    @IBOutlet weak var AddressTextFeild: UITextField!
    @IBOutlet weak var NumberOfRoomsTextFeild: UITextField!
    @IBOutlet weak var PriceTextFeild: UITextField!

    @IBOutlet weak var TypeOfOfferSeg: UISegmentedControl!
    @IBOutlet weak var TypeOfSellingSeg: UISegmentedControl!
    

    
    var SelectTypeOfOffer : String = ""
    @IBAction func TypeOfOfferSegment(_ sender: UISegmentedControl) {
        switch TypeOfOfferSeg.selectedSegmentIndex {
        case 0:
            print("=========================== 0")
            SelectTypeOfOffer = "House"

        case 1:
            print("=========================== 1")
            SelectTypeOfOffer = "Department"

            
        case 2:
            print("=========================== 2")
            SelectTypeOfOffer = "Land"


        default:
            let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of offer ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)        }
        
    }
    
    
    var SelectTypeOfselling : String = ""
    @IBAction func typeOfSellingSegment(_ sender: UISegmentedControl) {
        switch TypeOfSellingSeg.selectedSegmentIndex {
        case 0:
            print("=========================== 0")
            SelectTypeOfselling = "sell"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfselling = "Rent"
            
        default:
            let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of selling ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var ShowImage: UIImageView!
    var image1 : UIImage? = nil
    @IBAction func ChooseAPhotoButton(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            print("================================")
        
            self.image1 = image
            self.ShowImage.image = image
            
        }
    }
    
    
    @IBAction func AddYourNewButton(_ sender: UIButton) {
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let rendomNameImage = String.random()
            
            let storageRef = Storage.storage().reference().child("photos").child("\(rendomNameImage).jpg")
            //$$$$$$$$$$$$
//            To load: let image = UIImage(data: data)
            let data = image1!.jpegData(compressionQuality: 0.5)
            //$$$$$$$$$$$$
            _ = storageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard url != nil else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                     let myurl = url?.absoluteString
                    print("###############################")
                    let newItem = ItemObject(TypeOfOffer: self.SelectTypeOfOffer, TypeOfSelling: self.SelectTypeOfselling, Address: self.AddressTextFeild.text, NumberOfRoom: self.NumberOfRoomsTextFeild.text, Price: self.PriceTextFeild.text, Image: myurl, ID: myUID,itemId : itemId)
                        
                        newItem.Upload()
                    

                    
                    
                }
            }
           
        }
    }
    
    
    

    
    
    
    
    
    
    
    
    
}













 // it's convert to string
extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

// to create rendom name for image when upload it to firebase
extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}



