//
//  GuestFilteredItems.swift
//  FindHouseForMe
//
//  Created by Abdullah Jacksi on 3/31/19.
//  Copyright © 2019 Abdullah Jacksi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import DZNEmptyDataSet


class GuestFilteredItems: UIViewController , UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,  DZNEmptyDataSetDelegate {

    var arraySegueFiltered = [ItemModel]()

    
    
    
    
    @IBOutlet weak var tableViewFiltered: UITableView! {
        didSet {
            tableViewFiltered.delegate = self ;
            tableViewFiltered.dataSource = self ;
            tableViewFiltered.emptyDataSetSource = self
            tableViewFiltered.emptyDataSetDelegate = self
            tableViewFiltered.tableFooterView = UIView()
        }
    }
    
    
    
    
    
    
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewFiltered.register(UINib(nibName: "OfficeCell", bundle: nil), forCellReuseIdentifier: "myCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("))))))))))))))))))))(((((((((((((((((")
        print(arraySegueFiltered.count)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("raw ========= \(arrayItems[0].Address) \n\n\n")
        
        return arraySegueFiltered.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 692
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewFiltered.dequeueReusableCell(withIdentifier: "myCell") as! OfficeCell
        //        print("cell *********** \(self.arrayItems.count) \n\n\n")
        //        print("Auth.auth().currentUser?.uid>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(Auth.auth().currentUser?.uid)")
        //        print("arrayItems[0].ID >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\(arrayItems[0].ID)")
        
        let item : ItemModel
        item = arraySegueFiltered[indexPath.row]
        
        //MARK: download image
        if let imageDownloadURL = self.arraySegueFiltered[indexPath.row].Image {
            
            let url = URL(string: imageDownloadURL)
            cell.myImage.sd_setImage(with: url, placeholderImage: nil)
            
        }
        
        
        if arraySegueFiltered.count > 0 {
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
