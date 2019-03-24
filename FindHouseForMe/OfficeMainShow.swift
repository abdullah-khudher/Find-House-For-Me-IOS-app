//
//  OfficeMainShow.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase


class OfficeMainShow: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    
    
    @IBAction func addBarButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddNewButtonSegue", sender: nil)
    }
    
    
    @IBOutlet weak var myTableView: UITableView!
                                    { didSet {
                                            myTableView.delegate = self ;
                                            myTableView.dataSource = self ;
                                                   }     }
    
    
    var arrayItems = [ItemModel]()
    var checkSnapshotChildrenCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // MARK:longPressGesture1
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1
        longPressGesture.delegate = self
        self.myTableView.addGestureRecognizer(longPressGesture)
        
        
        myTableView.register(UINib(nibName: "OfficeCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        
        
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
                    let Price = itemObject?["Price"]
                    let Image = itemObject?["Image"]
                    let ID = itemObject?["ID"]
                    let itemId = itemObject?["itemId"]

                    
                    //creating artist object with model and fetched values
                    let item = ItemModel(TypeOfOffer: TypeOfOffer as! String?, TypeOfSelling: TypeOfSelling as! String?, Address: Address as! String?, NumberOfRoom: NumberOfRoom as! String?, Price: Price as! String?, Image: Image as! String?, ID: ID as! String?, itemId:itemId as! String? )
                    
                    //appending it to list
                    self.arrayItems.insert(item, at: 0)
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
            }else{
                
            }
        })
    
        
    }
    
    
    //MARK: to show massage when table view empty
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if checkSnapshotChildrenCount == 0
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "you didn't do any business yet (: "
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }else {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("raw ========= \(arrayItems[0].Address) \n\n\n")

        return arrayItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 692
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell") as! OfficeCell
//        print("cell *********** \(self.arrayItems.count) \n\n\n")

        
        let item : ItemModel
        item = arrayItems[indexPath.row]
        
        //MARK: download image
        if let imageDownloadURL = arrayItems[indexPath.row].Image {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 15 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("$$$$&&&&&$&$&$& \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            cell.myImage.image = image
                        }
                    }
                }
                
            }
        }
        
        
    
        
        if arrayItems.count > 0 {
            cell.typeOfferTextField?.text = item.TypeOfOffer
            cell.typeSellingTextFiled?.text = item.TypeOfSelling
            cell.addressTextField?.text = item.Address
            cell.numberRoomTextField?.text = item.NumberOfRoom
            cell.priceTextField?.text = item.Price
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
        self.myTableView.reloadData()


    }
    

    
    
    //MARK:longPressGesture 2
    var indexNumber : Int = 0
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditButtonSegue" {
            let controller = segue.destination as! OfficeEdit
            controller.itemEdating = self.arrayItems[(indexNumber)]
            
        }
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        
        let p = longPressGesture.location(in: self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizer.State.began) {
            print("Long press on row, at \(indexPath!.row)")
            let alert = UIAlertController(title: "Are you sure you want to edit?", message: "if you are sure just click on Yes button ... otherwise ckick on Cancel buuton", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                
                self.indexNumber = (indexPath?.row)!
                
                self.performSegue(withIdentifier: "EditButtonSegue", sender: nil)
  
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
            
            
        }
    }

    
    //MARK: profile Button
    @IBAction func profileButton(_ sender: Any) {
        
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "EditButtonSegue" {
//                let controller = segue.destination as! OfficeEdit
//                controller.itemEdating = self.arrayItems[0].Address?
//
//            }
//        }
        
        
        
    }
    
    
    
    

}
