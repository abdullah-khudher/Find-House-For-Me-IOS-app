//
//  GuestFilterByNameOfOffice.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 3/29/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import DZNEmptyDataSet




class GuestFilterByNameOfOffice: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,  DZNEmptyDataSetDelegate {

    
    
    
    @IBOutlet weak var GuestTabelViewNameSearch: UITableView!
    {
        didSet {
            GuestTabelViewNameSearch.delegate = self ;
            GuestTabelViewNameSearch.dataSource = self ;
            GuestTabelViewNameSearch.emptyDataSetSource = self
            GuestTabelViewNameSearch.emptyDataSetDelegate = self
//            GuestTabelViewNameSearch.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var nameTextFiled: UITextField!
    
    
    
    var arrayItems3 = [ItemModel]()
    var arrayItemsFiltered = [ItemModel]()
    var connectionId : String?
    
    
    
    
    
    @IBAction func searchButton(_ sender: Any) {
        
        _ = Database.database().reference().child("Users").observe(DataEventType.value, with: { (snapshot) in
            
                for Items in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let itemObject = Items.value as? [String: AnyObject]
                    
                    let NumeOfOffice  = itemObject?["NumeOfOffice"] as? String
                    let ID  = itemObject?["ID"] as? String


                    if self.nameTextFiled.text == NumeOfOffice  {
                        self.connectionId = ID
                        //   print(self.connection!Id)
                        
                        if let myConnectionId = self.connectionId {
                            
                            
                            _ = Database.database().reference().child("Items").observe(DataEventType.value, with: { (snapshot) in
                                
                                self.arrayItems3.removeAll()

                                    for Items in snapshot.children.allObjects as! [DataSnapshot] {
                                        //getting values
                                        let itemObject = Items.value as? [String: AnyObject]
                                        
                                        let ID = itemObject?["ID"] as! String?
                                        let TypeOfOffer  = itemObject?["TypeOfOffer"]
                                        let TypeOfSelling  = itemObject?["TypeOfSelling"]
                                        let Address = itemObject?["Address"]
                                        let NumberOfRoom = itemObject?["NumberOfRoom"]
                                        let NumberOfBath = itemObject?["NumberOfBath"]
                                        let HouseArea = itemObject?["HouseArea"]
                                        let Price = itemObject?["Price"]
                                        let Image = itemObject?["Image"]
                                        let itemId = itemObject?["itemId"]
                                        
                                        if myConnectionId == ID {
                                            //creating artist object with model and fetched values
                                            let item = ItemModel(TypeOfOffer: TypeOfOffer as! String?, TypeOfSelling: TypeOfSelling as! String?, Address: Address as! String?, NumberOfRoom: NumberOfRoom as! String? ,NumberOfBath: NumberOfBath as! String? , HouseArea: HouseArea as! String? ,Price: Price as! String?, Image: Image as! String?, ID: ID , itemId:itemId as! String? )
                                            
                                        
                                            self.arrayItems3.append(item)
                                            print("#########")
                                            print(self.arrayItems3.count)
                                        }
   
                                }
                                
                                
                                DispatchQueue.main.async { [weak self] in
                                    
                                    self?.GuestTabelViewNameSearch.reloadData()
                                }
                            })
                           
//                            print("+++++++++++")
//                            print(self.arrayItems3.count)
  
                        }
                    }

                    
                }
        })
//        print("=========")
//         print(self.arrayItems3.count)
    
    }
    
    
    @IBAction func CleanSearchButton(_ sender: UIButton) {
        nameTextFiled.text = ""
        self.arrayItems3.removeAll()
        DispatchQueue.main.async { [weak self] in
            self?.GuestTabelViewNameSearch.reloadData()
        }

    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GuestTabelViewNameSearch.register(UINib(nibName: "FirstOfficeCell", bundle: nil), forCellReuseIdentifier: "myCell4")
        
        
    }
    
    
    
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("raw ========= \(String(describing: arrayItems3.count)) \n\n\n")
        
        return arrayItems3.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = GuestTabelViewNameSearch.dequeueReusableCell(withIdentifier: "myCell4") as! FirstOfficeCell
        //        print("cell *********** \(self.arrayItems.count) \n\n\n")
        //        print("Auth.auth().currentUser?.uid>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(Auth.auth().currentUser?.uid)")
        //        print("arrayItems[0].ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(arrayItems[0].ID)")
        
        let item : ItemModel
        item = arrayItems3[indexPath.row]
        
        //MARK: download image
        if let imageDownloadURL = self.arrayItems3[indexPath.row].Image {
            
            let url = URL(string: imageDownloadURL)
            let chat = UIImage(named: "bic")
            cell.smallImageView.sd_setImage(with: url, placeholderImage: chat  )
            
        }
        
        
        if arrayItems3.count > 0 {
            cell.smallTextOffer?.text = item.TypeOfOffer
            cell.smallTextSelling?.text = item.TypeOfSelling
            cell.smallTextAddress?.text = item.Address
            cell.smallTextRoom?.text = item.NumberOfRoom
            cell.smallTextPrice?.text = "$ " + item.Price!
            cell.smallPlace?.text = item.HouseArea
            cell.smallBath?.text = item.NumberOfBath
        }
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    //MARK: to show massage when table view empty
    
    // Add title for empty dataset
    func title(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "مرحبا"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // Add description/subtitle on empty dataset
    func description(forEmptyDataSet _: UIScrollView!) -> NSAttributedString! {
        let str = "لم يتم اضافة اي عنصر جديد"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    //Add your image
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "map2")
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



