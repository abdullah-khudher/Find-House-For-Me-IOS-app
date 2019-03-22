//
//  OfficeAddNew.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit

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
    var image1: UIImage? = nil
    @IBAction func ChooseAPhotoButton(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            print("================================")
            self.image1 = image
            self.ShowImage.image = self.image1
            
        }
    }
    
    
    @IBAction func AddYourNewButton(_ sender: UIButton) {
        
        
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



class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        pickImageCallback?(image)
//    }
    
      // For Swift 4.2
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          guard let image = info[.originalImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          }
          pickImageCallback?(image)
      }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}
