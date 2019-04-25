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
import SDWebImage


class OfficeAddNew: UIViewController  {
    
    
    @IBOutlet weak var AddressTextFeild: UITextField!
    @IBOutlet weak var NumberOfRoomsTextFeild: UITextField!
    @IBOutlet weak var NumberOFBathsTextField: UITextField!
    @IBOutlet weak var HouseAreaTextField: UITextField!
    @IBOutlet weak var PriceTextFeild: UITextField!

    @IBOutlet weak var TypeOfOfferSeg: UISegmentedControl!
    @IBOutlet weak var TypeOfSellingSeg: UISegmentedControl!
    
    
    
    
    
    //MARK: show keyboard 1
    @IBOutlet weak var scrollView: UIScrollView!
    @objc func adjustInsetForKeyboard(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let show = (notification.name == UIResponder.keyboardWillShowNotification)
            ? true
            : false
        
        let adjustmentHeight = keyboardFrame.height  * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
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
            
            
            
            
        chickEditing = false
        
        self.navigationItem.title = "Add"
            
            
    }
    
   
    
    
    
    
    
    
    
    var SelectTypeOfOffer : String = ""
    @IBAction func typeOfOfferSegment(_ sender: UISegmentedControl) {
        switch TypeOfOfferSeg.selectedSegmentIndex {
        case 0:
            print("=========================== 0")
            SelectTypeOfOffer = "بيت"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfOffer = "شقة"
            
            
        case 2:
            print("=========================== 2")
            SelectTypeOfOffer = "أرض"
            
            
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
            SelectTypeOfselling = "بيع"
            
        case 1:
            print("=========================== 1")
            SelectTypeOfselling = "أيجار"
            
        default:
            let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of selling ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    
    
    
    
    @IBOutlet weak var ShowImage: UIImageView!
    var image1 : UIImage? = nil
    @IBAction func ChoosePhotoButton(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            print("================================")
            
            self.image1 = image
            self.ShowImage.image = image
            
        }
    }


    
    
    

    
    @IBAction func AddYourNewButton(_ sender: UIButton)  {
        

        
//        sender.setTitle("asd", for: .highlighted)

        if SelectTypeOfOffer == "" || SelectTypeOfselling == "" || AddressTextFeild.text == "" || NumberOfRoomsTextFeild.text == "" ||
            NumberOFBathsTextField.text == "" || HouseAreaTextField.text == "" || PriceTextFeild.text == "" || image1 == nil {
            print("!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#!@#")
            
            let alert = UIAlertController(title: "تنبيه", message: "يجب ادخال كل البيانات ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "نعم", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if let myUID = Auth.auth().currentUser?.uid {
            
            let rendomNameImage = String.random()
            
            
            let storageRef = Storage.storage().reference().child("photos").child("\(rendomNameImage).jpg")
            //$$$$$$$$$$$$
            //            To load: let image = UIImage(data: data)
            let data = image1!.jpegData(compressionQuality: 0.5)
            //$$$$$$$$$$$$
            if let mydata = data {
                
                
                _ = storageRef.putData(mydata, metadata: nil) { (metadata, error) in
                    guard metadata != nil else {
                        print("metadata ###############################")
                        return
                    }
                    // You can also access to download URL after upload.
                    storageRef.downloadURL { (url, error) in
                        guard url != nil else {
                            print("url ###############################")
                            return
                        }
                        
                        let myurl = url?.absoluteString
                        print("okay ###############################")
                         
                        
                       let newItem = ItemObject(TypeOfOffer: self.SelectTypeOfOffer , TypeOfSelling: self.SelectTypeOfselling , Address: self.AddressTextFeild.text , NumberOfRoom: self.NumberOfRoomsTextFeild.text , NumberOfBath : self.NumberOFBathsTextField.text , HouseArea : self.HouseAreaTextField.text , Price: self.PriceTextFeild.text, Image: myurl, ID: myUID,itemId : itemId)
                        
                        newItem.Upload()
                        
                        
//                        self.dismiss(animated: true, completion: nil)
                        
                        
                        
                    }
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


//MARK: show keyboard 3
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




