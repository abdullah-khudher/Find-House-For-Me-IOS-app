//
//  GuestMainShow.swift
//  
//
//  Created by Abdullah Jacksi on 3/25/19.
//

import UIKit
import Firebase
import SDWebImage
import DZNEmptyDataSet

class GuestMainShow: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,  DZNEmptyDataSetDelegate {
    
    
    
    var arrayItems = [ItemModel]()
    

    
    @IBOutlet weak var GuestTableView: UITableView!
        
        {
        didSet {
            GuestTableView.delegate = self ;
            GuestTableView.dataSource = self ;
            GuestTableView.emptyDataSetSource = self
            GuestTableView.emptyDataSetDelegate = self
            GuestTableView.tableFooterView = UIView()
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for table view
        GuestTableView.register(UINib(nibName: "OfficeCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        
        
        /*      ?????????????????????????????????????????????????????????????????
         //MARK: get items from database
         how to make the code below to function
         ?????????????????????????????????????????????????????????????????             */
        _ = Database.database().reference().child("Items").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
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
                    self?.GuestTableView.reloadData()
                }
                // or
                //                  self?.myTableView.reloadData()
                // or
                //                Threads.performTaskInMainQueue {
                //                    self.myTableView.reloadData()
                //                }
            }else{
                print("======================== \n there is no return data because snapshot.childrenCount = 0 ")
            }
        })
        
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("raw ========= \(arrayItems[0].Address) \n\n\n")
        
        return arrayItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 692
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GuestTableView.dequeueReusableCell(withIdentifier: "myCell") as! OfficeCell
        //        print("cell *********** \(self.arrayItems.count) \n\n\n")
        //        print("Auth.auth().currentUser?.uid>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(Auth.auth().currentUser?.uid)")
        //        print("arrayItems[0].ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(arrayItems[0].ID)")
        
        let item : ItemModel
        item = arrayItems[indexPath.row]
        
        //MARK: download image
        if let imageDownloadURL = self.arrayItems[indexPath.row].Image {
            
            let url = URL(string: imageDownloadURL)
            cell.myImage.sd_setImage(with: url, placeholderImage: nil)
            
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

    
    
    
    
    

}
