//
//  OfficeEdit.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Foundation
import Firebase


var editingItemId :String?


class OfficeEdit: UIViewController {

    var itemEdating:ItemModel?

    
    @IBOutlet weak var AddressTextFeild: UITextField!
    @IBOutlet weak var NumberOfRoomsTextFeild: UITextField!
    @IBOutlet weak var PriceTextFeild: UITextField!
    
    @IBOutlet weak var TypeOfOfferSeg2: UISegmentedControl!
    @IBOutlet weak var TypeOfSellingSeg2: UISegmentedControl!
    
    @IBOutlet weak var ShowImage2: UIImageView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("***************************\((self.itemEdating?.TypeOfSelling)!)***********************")
        self.hideKeyboardWhenTappedAround()

        self.navigationItem.title = "Edit"
        
        //MARK:show the item on screen1
        AddressTextFeild.text = itemEdating?.Address
        NumberOfRoomsTextFeild.text = itemEdating?.NumberOfRoom
        PriceTextFeild.text = itemEdating?.Price
        
        if (itemEdating?.TypeOfOffer) == "House" {
            TypeOfOfferSeg2.selectedSegmentIndex = 0
        }else if (itemEdating?.TypeOfOffer) == "Department" {
            TypeOfOfferSeg2.selectedSegmentIndex = 1
        }else  {
            TypeOfOfferSeg2.selectedSegmentIndex = 2
        }
        
        if (itemEdating?.TypeOfSelling) == "sell" {
            TypeOfSellingSeg2.selectedSegmentIndex = 0
        }else if (itemEdating?.TypeOfSelling) == "Rent" {
            TypeOfSellingSeg2.selectedSegmentIndex = 1

        }

        if let imageDownloadURL = itemEdating!.Image {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("$$$$&&&#####################&&$&$&$& \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        if let myimage = image{
//                            DispatchQueue.main.async {
                                self!.ShowImage2.image = myimage
                                self!.image2 = myimage
                                //                        }
                        }else{
                            self!.ShowImage2.backgroundColor = UIColor.red
                        }
//
                    }
                }
            }
        }
    }
    
    
    
    //MARK:upload item to database after edit it
    
    
    var SelectTypeOfOffer2 : String = ""
    @IBAction func typeOfOfferSegment2(_ sender: UISegmentedControl) {
        switch TypeOfOfferSeg2.selectedSegmentIndex {
        case 0:
            print("=========================== 0")
            SelectTypeOfOffer2 = "House"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfOffer2 = "Department"
            
            
        case 2:
            print("=========================== 2")
            SelectTypeOfOffer2 = "Land"
            
            
        default:
            let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of offer ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)        }
    }
    

    var SelectTypeOfselling2 : String = ""
    @IBAction func typeOfSellingSegment2(_ sender: UISegmentedControl) {
        switch TypeOfSellingSeg2.selectedSegmentIndex {
        case 0:
            print("=========================== 0")
            SelectTypeOfselling2 = "sell"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfselling2 = "Rent"
            
        default:
            let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of selling ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    





    var pressChooseImageBuuton : Bool = false
    var image2 : UIImage? = nil

    var image1 : UIImage? = nil
    @IBAction func ChooseAPhotoButton(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            print("================================")
            
            self.image1 = image
            self.ShowImage2.image = image

            if self.image1 != self.image2 {
                self.pressChooseImageBuuton = true
            }
        }
    }



    @IBAction func AddYourNewButton(_ sender: UIButton) {

        // delete image when old image does not same with new image
        if pressChooseImageBuuton {
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: (itemEdating?.Image)!)
            storageRef.delete { error in
                if let error = error {
                    print(error)
                } else {

                    
                        let rendomNameImage = String.random2()
                        
                        let storageRef = Storage.storage().reference().child("photos").child("\(rendomNameImage).jpg")
                        //$$$$$$$$$$$$
                        //            To load: let image = UIImage(data: data)
                        //            var data: Data?
                        let data = self.image1?.jpegData(compressionQuality: 0.5)
                        
                        if let mydata = data {
                            
                            _ = storageRef.putData(mydata, metadata: nil) { (metadata, error) in
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
                                    
                                    let myurl2 = url?.absoluteString
                                    print("><><<><><><><><><>>><><><><<>>>>>>><><><><<><><><><>")
                                    
                                    if self.SelectTypeOfOffer2.isEmpty{
                                        self.SelectTypeOfOffer2 = (self.itemEdating?.TypeOfOffer)!
                                    }
                                    if self.SelectTypeOfselling2.isEmpty{
                                        self.SelectTypeOfselling2 = (self.itemEdating?.TypeOfSelling)!
                                    }
                                    // to make item refrence same for old one
                                    chickEditing = true
                                    editingItemId = self.itemEdating?.itemId
                                    
                                    let newItem = ItemObject(TypeOfOffer: self.SelectTypeOfOffer2, TypeOfSelling: self.SelectTypeOfselling2, Address: self.AddressTextFeild.text, NumberOfRoom: self.NumberOfRoomsTextFeild.text, Price: self.PriceTextFeild.text, Image: myurl2, ID: self.itemEdating?.ID, itemId : editingItemId)
                                    
                                    newItem.Upload()
                                    
                                    
                                }
                            }
                        
                    }
                }
            }
        }else{
            
            
                        
                print("><><<><><><><><><>>><><><><<>>>>>>><><><><<><><><><>")
                
                if self.SelectTypeOfOffer2.isEmpty{
                    self.SelectTypeOfOffer2 = (self.itemEdating?.TypeOfOffer)!
                }
                if self.SelectTypeOfselling2.isEmpty{
                    self.SelectTypeOfselling2 = (self.itemEdating?.TypeOfSelling)!
                }
                // to make item refrence same for old one
                chickEditing = true
                editingItemId = self.itemEdating?.itemId
                
                let newItem = ItemObject(TypeOfOffer: self.SelectTypeOfOffer2, TypeOfSelling: self.SelectTypeOfselling2, Address: self.AddressTextFeild.text, NumberOfRoom: self.NumberOfRoomsTextFeild.text, Price: self.PriceTextFeild.text, Image: itemEdating?.Image, ID: itemEdating?.ID, itemId : editingItemId)
            
                newItem.Upload()
                
                

            }



        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}













// it's convert to string
extension UIImage {
    func toString2() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

// to create rendom name for image when upload it to firebase
extension String {
    static func random2(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}


