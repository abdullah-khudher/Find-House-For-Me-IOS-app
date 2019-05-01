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
import SDWebImage


var editingItemId :String?


class OfficeEdit: UIViewController {

    var itemEdating:ItemModel?

    
    @IBOutlet weak var AddressTextFeild: UITextField!
    @IBOutlet weak var NumberOfRoomsTextFeild: UITextField!
    @IBOutlet weak var NumberOFBathsTextField: UITextField!
    @IBOutlet weak var HouseAreaTextField: UITextField!
    @IBOutlet weak var PriceTextFeild: UITextField!
    
    @IBOutlet weak var TypeOfOfferSeg2: UISegmentedControl!
    @IBOutlet weak var TypeOfSellingSeg2: UISegmentedControl!
    
    @IBOutlet weak var ShowImage2: UIImageView!

    
    //MARK: show keyboard 1
    @IBOutlet weak var scrollView2: UIScrollView!
    
    @objc func adjustInsetForKeyboard(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let show = (notification.name == UIResponder.keyboardWillShowNotification)
            ? true
            : false

        let adjustmentHeight = keyboardFrame.height  * (show ? 1 : -1)
        scrollView2.contentInset.bottom += adjustmentHeight
        scrollView2.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        //MARK: show keyboard 2
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustInsetForKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustInsetForKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        self.hideKeyboardWhenTappedAround()

        
        
        
        chickEditing = true

        self.navigationItem.title = "Edit"
        
        //MARK:show the item on screen 1
        print(itemEdating?.Address)
        print("dddd\n\n\n")
        AddressTextFeild.text = itemEdating?.Address
        NumberOfRoomsTextFeild.text = itemEdating?.NumberOfRoom
        NumberOFBathsTextField.text = itemEdating?.NumberOfBath
        HouseAreaTextField.text = itemEdating?.HouseArea
        PriceTextFeild.text = itemEdating?.Price
        
        if (itemEdating?.TypeOfOffer) == "بيت" {
            TypeOfOfferSeg2.selectedSegmentIndex = 0
        }else if (itemEdating?.TypeOfOffer) == "شقة" {
            TypeOfOfferSeg2.selectedSegmentIndex = 1
        }else  {
            TypeOfOfferSeg2.selectedSegmentIndex = 2
        }
        
        if (itemEdating?.TypeOfSelling) == "بيع" {
            TypeOfSellingSeg2.selectedSegmentIndex = 0
        }else if (itemEdating?.TypeOfSelling) == "ايجار" {
            TypeOfSellingSeg2.selectedSegmentIndex = 1

        }

        if let imageDownloadURL = itemEdating?.Image {
            
            let url = URL(string: imageDownloadURL)
            let chat = UIImage(named: "bic")
            ShowImage2.sd_setImage(with: url, placeholderImage: chat  )
            
        }
    }
    
    
    
    //MARK:upload item to database after edit it
    
    
    var SelectTypeOfOffer2 : String = ""
    @IBAction func typeOfOfferSegment2(_ sender: UISegmentedControl) {
        switch TypeOfOfferSeg2.selectedSegmentIndex {
        case 0:
            print("=========================== 0")
            SelectTypeOfOffer2 = "house"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfOffer2 = "department"
            
            
        case 2:
            print("=========================== 2")
            SelectTypeOfOffer2 = "land"
            
            
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
            SelectTypeOfselling2 = "buy"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfselling2 = "rent"
            
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



    @IBAction func AddYourNewButton(_ button: UIButton) {

        // if i did not change type of offer and type of selling
        if self.SelectTypeOfOffer2.isEmpty{
            self.SelectTypeOfOffer2 = (self.itemEdating?.TypeOfOffer)!
        }
        if self.SelectTypeOfselling2.isEmpty{
            self.SelectTypeOfselling2 = (self.itemEdating?.TypeOfSelling)!
        }

        // to show massage when some item empty
        if SelectTypeOfOffer2 == "" || SelectTypeOfselling2 == "" || AddressTextFeild.text == "" || NumberOfRoomsTextFeild.text == "" ||  NumberOFBathsTextField.text == "" || HouseAreaTextField.text == "" || PriceTextFeild.text == "" {
            print("!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#")
            
            let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of offer ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        // MARK: delete image when old image does not same with new image
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
                                    
                                    let newItem = ItemObject(TypeOfOffer: self.SelectTypeOfOffer2, TypeOfSelling: self.SelectTypeOfselling2, Address: self.AddressTextFeild.text, NumberOfRoom: self.NumberOfRoomsTextFeild.text , NumberOfBath : self.NumberOFBathsTextField.text , HouseArea : self.HouseAreaTextField.text , Price: self.PriceTextFeild.text, Image: myurl2, ID: self.itemEdating?.ID, itemId : editingItemId)
                                    
                                    newItem.Upload()
                                    self.dismiss(animated: true, completion: nil)

                                    
                                }
                            }
                        
                    }
                }
            }
        }else{
            
            
                        
                print("><><<><><><><><><>>><><>++++++++++++++++++++<<>>>>>>><><><><<><><><><>")
                
            
                // to make item refrence same for old one
                chickEditing = true
                editingItemId = self.itemEdating?.itemId
                
                let newItem = ItemObject(TypeOfOffer: self.SelectTypeOfOffer2, TypeOfSelling: self.SelectTypeOfselling2, Address: self.AddressTextFeild.text, NumberOfRoom: self.NumberOfRoomsTextFeild.text , NumberOfBath : self.NumberOFBathsTextField.text , HouseArea : self.HouseAreaTextField.text , Price: self.PriceTextFeild.text, Image: itemEdating?.Image, ID: self.itemEdating?.ID, itemId : editingItemId)
            
                newItem.Upload()
                self.dismiss(animated: true, completion: nil)

                

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


