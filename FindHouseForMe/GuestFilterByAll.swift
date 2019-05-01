//
//  GuestFilterByAll.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 3/30/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SDWebImage



class GuestFilterByAll: UIViewController {

    
    var arrayItems4 = [ItemModel]()
    var arrayItemsTransfer = [ItemModel]()
    var itemTransfer = ItemModel(TypeOfOffer: "", TypeOfSelling: "", Address: "", NumberOfRoom: "", NumberOfBath: "", HouseArea: "", Price: "", Image: "", ID: "", itemId: "")

    @IBOutlet weak var offerSeg: UISegmentedControl!
    @IBOutlet weak var sellingSeg: UISegmentedControl!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var NumberOFBathsTextField: UITextField!
    @IBOutlet weak var HouseAreaTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    
    
    var SelectTypeOfOffer : String = ""
    @IBAction func offerSegAction(_ sender: Any) {
            switch offerSeg.selectedSegmentIndex {
            case 0:
                print("=========================== 0")
                SelectTypeOfOffer = "house"
                
            case 1:
                print("=========================== 1")
                SelectTypeOfOffer = "department"
                
                
            case 2:
                print("=========================== 2")
                SelectTypeOfOffer = "land"
                
                
            default:
                let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of offer ", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)        }
    }
    
    
    var SelectTypeOfselling : String = ""
    @IBAction func sellingSegAction(_ sender: Any) {
            switch sellingSeg.selectedSegmentIndex {
            case 0:
                print("=========================== 0")
                SelectTypeOfselling = "buy"
                
            case 1:
                print("=========================== 1")
                SelectTypeOfselling = "rent"
                
            default:
                let alert = UIAlertController(title: "OPPS!", message: "You didn't choose any tpye of selling ", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        
        
    }
    
    
    
    
    //MARK: show keyboard 1
    @IBOutlet weak var scrollViewFilter: UIScrollView!
    @objc func adjustInsetForKeyboard(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let show = (notification.name == UIResponder.keyboardWillShowNotification)
            ? true
            : false
        
        let adjustmentHeight = keyboardFrame.height  * (show ? 1 : -1)
        scrollViewFilter.contentInset.bottom += adjustmentHeight
        scrollViewFilter.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    
    
    
    
    
    
    @IBAction func searchButton(_ sender: Any) {
        
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        print(arrayItems4.count)
        

        
        arrayItemsTransfer = []
        itemTransfer = ItemModel(TypeOfOffer: "", TypeOfSelling: "", Address: "", NumberOfRoom: "" , NumberOfBath: "", HouseArea: "", Price: "", Image: "", ID: "", itemId: "")

        
        
        if let addressTextField1 = addressTextField.text , let roomsTextField1 = roomsTextField.text , let NumberOFBathsTextField1 = NumberOFBathsTextField.text , let HouseArea1 = HouseAreaTextField.text ,  let priceTextField1 = priceTextField.text {
            
            itemTransfer.TypeOfOffer = SelectTypeOfOffer
            itemTransfer.TypeOfSelling = SelectTypeOfselling
            itemTransfer.Address = addressTextField1
            itemTransfer.NumberOfRoom = roomsTextField1
            itemTransfer.NumberOfBath = NumberOFBathsTextField1
            itemTransfer.HouseArea = HouseArea1
            itemTransfer.Price = priceTextField1
            
            //
            //            print("\n\n%%%%%%%%%%%%% offer %%%%%%%%%%%%%")
            //            print(SelectTypeOfOffer)
        }
        
        

        
        for items in arrayItems4 {

            if itemTransfer == items{
                
                arrayItemsTransfer.append(items)
            
            }
        }
        
        
//        print("\n\n%%%%%%%%%%%%%  count %%%%%%%%%%%%%")
//        print(arrayItemsTransfer.count)
        SelectTypeOfOffer = ""
        SelectTypeOfselling = ""
    
        performSegue(withIdentifier: "showFilteredItems", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC : GuestFilteredItems = segue.destination as! GuestFilteredItems
        destVC.arraySegueFiltered = arrayItemsTransfer
    }
    
    
    
    @IBAction func cleanSearch(_ sender: UIButton) {
        
        offerSeg.selectedSegmentIndex = -1
        sellingSeg.selectedSegmentIndex = -1
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
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
        
        
        
        
        
        //MARK: get data from firebase
        _ = Database.database().reference().child("Items").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.arrayItems4.removeAll()
                //iterating through all the values
                for Items in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let itemObject = Items.value as? [String: AnyObject]
                    
                    let TypeOfOffer  = itemObject?["TypeOfOffer"]
                    let TypeOfSelling  = itemObject?["TypeOfSelling"]
                    let Address = itemObject?["Address"]
                    let NumberOfRoom = itemObject?["NumberOfRoom"]
                    let NumberOfBath = itemObject?["NumberOfBath"]
                    let HouseArea = itemObject?["HouseArea"]
                    let Price = itemObject?["Price"]
                    let Image = itemObject?["Image"]
                    let ID = itemObject?["ID"]
                    let itemId = itemObject?["itemId"]
                    
                    
                    //creating artist object with model and fetched values
                    let item = ItemModel(TypeOfOffer: TypeOfOffer as! String?, TypeOfSelling: TypeOfSelling as! String?, Address: Address as! String?, NumberOfRoom: NumberOfRoom as! String? ,NumberOfBath: NumberOfBath as! String? , HouseArea: HouseArea as! String? ,Price: Price as! String?, Image: Image as! String?, ID: ID as! String?, itemId:itemId as! String? )
                    
                    
                    //appending it to list
                    self.arrayItems4.append(item)
                    
                    
                }
                
                //reloading the tableview
//                DispatchQueue.main.async { [weak self] in
//                    self?.GuestTableView.reloadData()
//                }
                
            }else{
                print("======================== \n there is no return data because snapshot.childrenCount = 0 ")
            }
        })
        
        
        
        
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        offerSeg.selectedSegmentIndex = -1
        sellingSeg.selectedSegmentIndex = -1
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








