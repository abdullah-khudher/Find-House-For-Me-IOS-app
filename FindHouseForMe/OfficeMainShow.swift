//
//  OfficeMainShow.swift
//  AkurMe
//
//  Created by Abdullah Jacksi on 3/17/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase


class OfficeMainShow: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var myTableView: UITableView!
                                    { didSet {
                                            myTableView.delegate = self ;
                                            myTableView.dataSource = self ;
                                            self.myTableView.reloadData()       }     }
    
    
    var arrayItems : [GetItemFromFirebase] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.register(UINib(nibName: "OfficeCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        
        
        // download items
        Database.database().reference().child("Items").childByAutoId().observe(.childAdded) { (snapshot) in
            // snapshot is now a dictionary
            
            let newItem = GetItemFromFirebase(snapshot: snapshot)
            
            DispatchQueue.main.async {
                self.arrayItems.insert(newItem, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.myTableView.insertRows(at: [indexPath], with: .top)
            }
        }
        
        
        
    
        print("did load ======$$$$$$$$$$$$$$===== \(self.arrayItems.count) \n\n\n")

        
        
//        if arrayItems.count == 0 {
//        }
//        else if arrayItems.count != 0{
//        ItemAPI.CurrentItem { (item) in
//
//            self.arrayItems.append(item!)
//            print("===== \(self.arrayItems.count) \n\n\n")
//
//          }
//      }
    
        
        
        
//        // download image
//        if let imageDownloadURL = post.downloadURL {
//            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
//            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
//                if let error = error {
//                    print("******** \(error)")
//                } else {
//                    if let imageData = data {
//                        let image = UIImage(data: imageData)
//                        DispatchQueue.main.async {
//                            self?.postImageView.image = image
//                        }
//                    }
//                }
//
//            }
//        }
        
        //  DispatchQueue.main.async
//        var newItemAsyc : ItemObject? = nil
//            newItemAsyc = newUser
//        DispatchQueue.main.async {
//        self.myTableView.reloadData()
//            self.arrayItems.insert(newItemAsyc!, at: 0)
//            let indexPath = IndexPath(row: 0, section: 0)
//            self.myTableView.insertRows(at: [indexPath], with: .top)
//        }
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("raw ========= \(arrayItems[0].Address) \n\n\n")

        return 3
//        arrayItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 692
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell") as! OfficeCell
        print("cell *********** \(self.arrayItems.count) \n\n\n")

//        cell.typeOfferTextField?.text = arrayItems[indexPath.row].TypeOfOffer
//        cell.typeSellingTextFiled?.text = arrayItems[indexPath.row].TypeOfSelling
//        cell.addressTextField?.text = arrayItems[indexPath.row].Address
//        cell.numberRoomTextField?.text = arrayItems[indexPath.row].NumberOfRoom
//        cell.priceTextField?.text = arrayItems[indexPath.row].Price

        return cell
    }
    

    
//        self.performSegue(withIdentifier: "EditButtonSegue", sender: nil)
//    
//        self.performSegue(withIdentifier: "AddNewButtonSegue", sender: nil)


    
    
    

    
    
    
    

}
