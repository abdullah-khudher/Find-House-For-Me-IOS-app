//
//  OfficeMainShow.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Foundation

import Firebase

import SDWebImage
import Lottie
import DZNEmptyDataSet

class OfficeMainShow: UIViewController, UIGestureRecognizerDelegate, DZNEmptyDataSetSource,  DZNEmptyDataSetDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    
    
    
//    // to go to add Bar Button
//    @IBAction func BackBarButton(_ sender: UIBarButtonItem) {
//        self.performSegue(withIdentifier: "BackButtonSegue", sender: nil)
//    }
    
    
    
    @IBOutlet weak var myTableView: UITableView!
                                    { didSet {
                                            myTableView.delegate = self ;
                                            myTableView.dataSource = self ;
                                            myTableView.emptyDataSetSource = self
                                            myTableView.emptyDataSetDelegate = self
                                        //MARK : what is this ????? myTableView.tableFooterView = UIView()
//                                            myTableView.tableFooterView = UIView()
                                                   }     }
    
    
    var arrayItems = [ItemModel](){ didSet {
                                        DispatchQueue.main.async { [weak self] in
                                        self?.myTableView.reloadData()
                                                }
                                    }
                                    }
    
    
    // to chick if table view empty or not if so show massage " you didn't do any business yet (:  "
    var checkSnapshotChildrenCount : Int?
    
    
    
    //MARK: animation part 1
//    add this LOTAnimationView to my animationView
//    @IBOutlet weak var animationView: LOTAnimationView!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //MARK: animation part 2
//        animationView.isHidden = true
//        animationView.setAnimation(named: "PinJump")
//        animationView.loopAnimation = true
//        animationView.play()

        
        
        self.hideKeyboardWhenTappedAround()

        
        
        //
//        // MARK:longPressGesture 1
//        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressGesture.minimumPressDuration = 1
//        longPressGesture.delegate = self
//        self.myTableView.addGestureRecognizer(longPressGesture)
        
        
        
        // for table view
        myTableView.register(UINib(nibName: "FirstOfficeCell", bundle: nil), forCellReuseIdentifier: "myCell5")
        
        
        
/*      ?????????????????????????????????????????????????????????????????
         //MARK: get items from database
         how to make the code below to function
        ?????????????????????????????????????????????????????????????????             */
        _ = Database.database().reference().child("Items").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                self.checkSnapshotChildrenCount = Int(snapshot.childrenCount)
                //clearing the list
                self.arrayItems.removeAll()
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
                    
                    if let currnetItemId = item.ID ,  let currentUserId = Auth.auth().currentUser?.uid {

                        if currnetItemId == currentUserId {
                            
                            //appending it to list
                            self.arrayItems.insert(item, at: 0)

                        }
                    }
                }
                
                //reloading the tableview
                DispatchQueue.main.async { [weak self] in
                    self?.myTableView.reloadData()
                }
                // or
//                  self?.myTableView.reloadData()
                // or
//                Threads.performTaskInMainQueue {
//                    self.myTableView.reloadData()
//                }
                
//                print("count  ===================")
//                print(self.arrayItems.count)
            }else{
//                print("count2  ===================")
//                print(self.arrayItems.count)
            }
            print(")))))))))))))))((((((((((((")
            print(self.arrayItems.count)
            
        })
    
        print("count down arrayItems ===================")
        print(arrayItems.count)
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////// MARK:tab bar buttons ///////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //right buttons
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(OfficeMainShow.addTapped))
        
        let rightSpaceBetEditAndAddItem:UIBarButtonItem = UIBarButtonItem(title: "   ", style: UIBarButtonItem.Style.plain, target: self, action: #selector(OfficeMainShow.justSpaceBetEditAndAdd))
        
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(OfficeMainShow.editCell))
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem,rightSpaceBetEditAndAddItem,rightSearchBarButtonItem], animated: true)
        
        
    }
    
    
    //right buttons
    @objc func editCell(sender:UIButton) {
        let alert = UIAlertController(title: "Note!", message: "if you want to edit one of your items just long Press Gesture on a item which you want to edit", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func justSpaceBetEditAndAdd (sender:UIButton) {
        print(" just Space Between Edit And Add ")
    }
    @objc func addTapped (sender:UIButton) {
        self.performSegue(withIdentifier: "addButtonSegue", sender: nil)
    }
    
    
    
    
    //    MARK: profile Button
    @IBAction func profileButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goEditPage", sender: nil)

        //        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //            if segue.identifier == "EditButtonSegue" {
        //                let controller = segue.destination as! OfficeEdit
        //                controller.itemEdating = self.arrayItems[0].Address?
        //
        //            }
        //        }
        
    }
    
    
   
    
    
    
    
    
    
    
    
    
    //MARK: main part of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("raw ========= \(self.arrayItems.count) \n\n\n")
        
        //MARK: animation part 3
//        if arrayItems.count != 0{
//            animationView.pause()
//            animationView.isHidden = true
//        }
     
        
        return self.arrayItems.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "myCell5") as! FirstOfficeCell
        //        print("cell *********** \(self.arrayItems.count) \n\n\n")
        //        print("Auth.auth().currentUser?.uid>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(Auth.auth().currentUser?.uid)")
        //        print("arrayItems[0].ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(arrayItems[0].ID)")
        
        let item : ItemModel
        item = self.arrayItems[indexPath.row]
        
        //MARK: download image
        if let imageDownloadURL = self.arrayItems[indexPath.row].Image {
            
            let url = URL(string: imageDownloadURL)
            let chat = UIImage(named: "bic")
            cell.smallImageView.sd_setImage(with: url, placeholderImage: chat  )
            
        }
        
        
        if arrayItems.count > 0 {
            cell.smallTextOffer?.text = item.TypeOfOffer
            cell.smallTextSelling?.text = item.TypeOfSelling
            cell.smallTextAddress?.text = item.Address
            cell.smallTextRoom?.text = item.NumberOfRoom
            cell.smallTextPrice?.text = item.Price
            cell.smallPlace?.text = item.HouseArea
            cell.smallBath?.text = item.NumberOfBath
        }
        
        return cell
    }
    
    
    
    // MARK: delete Action
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let itemREF = arrayItems[indexPath.row].itemId
        let imageREF = arrayItems[indexPath.row].Image
        
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: imageREF!)
        storageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
            }
        }
        
        Database.database().reference().child("Items").child(itemREF!).removeValue()
        
        arrayItems.remove(at: indexPath.row)
        let deleteIndex = [indexPath]
        tableView.deleteRows(at: deleteIndex, with: .automatic)
//        self.myTableView.reloadData()


    }
    
    
    
    
    
    
    
    //MARK: to show massage when table view empty
    
    // Add title for empty dataset
    func title(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "Welcome"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // Add description/subtitle on empty dataset
    func description(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "Tap the button below to add your first grokkleglob."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //Add your image
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "map")
    }


    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\n\n###################################\n\n\n")
        let alert = UIAlertController(title: "Note!", message: "good try", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
//    //MARK:longPressGesture 2
//    var indexNumber : Int = 0
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EditButtonSegue" {
//            let controller = segue.destination as! OfficeEdit
//            controller.itemEdating = self.arrayItems[(indexNumber)]
//
//        }
//    }
//
//    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
//
//        let p = longPressGesture.location(in: self.myTableView)
//        let indexPath = self.myTableView.indexPathForRow(at: p)
//        if indexPath == nil {
//            print("Long press on table view, not row.")
//        }
//        else if (longPressGesture.state == UIGestureRecognizer.State.began) {
//            print("Long press on row, at \(indexPath!.row)")
//            let alert = UIAlertController(title: "Are you sure you want to edit?", message: "if you are sure just click on Yes button ... otherwise ckick on Cancel buuton", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//
//
//                self.indexNumber = (indexPath?.row)!
//
//                self.performSegue(withIdentifier: "EditButtonSegue", sender: nil)
//
//            }))
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//            self.present(alert, animated: true)
//
//
//
//        }
//    }

    

    
    
    
    
/////////////////////////////////////////////
}







