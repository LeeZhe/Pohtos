//
//  PhotosSelectVC.swift
//  Photos
//
//  Created by KiddieBao on 2018/3/30.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import Alamofire

struct Constants{
    static let Google_Map_key = "AIzaSyBC4BWKboY6NhAg9qNzhuiZOolFpakrVgs"
    static let Google_Map_Api = "https://maps.googleapis.com/maps/api/geocode/json"
}
class PhotosSelectVC: UITableViewController {
    var sources = Array<Array<PHAsset>>()
    var selectImages = Array<Array<UIImage>>()
    
    var dicts = Array<Dictionary<String , Any>>()
    var allDict = [Array<Dictionary<String , Any>>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(PhtotsCell.self, forCellReuseIdentifier: NSStringFromClass(PhtotsCell.self))
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add Photo", style: .plain, target: self, action: #selector(didSelectAddAction))
        
        self.navigationItem.title = "Photos"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Photos Analysis", style: .plain, target: self, action: #selector(didSelectAnalysis))
        
        DispatchQueue.global().async {
            PCPhotoManager.defaultManager.getMoments()
        }

    }
    
    
    @objc func didSelectAnalysis(){
        
        
        let traveSelectVC = TravePhotoSelVC()
        navigationController?.pushViewController(traveSelectVC, animated: true)
        
        /*
        let actionSheet = ZLPhotoActionSheet()
        actionSheet.configuration.maxSelectCount = 1
        actionSheet.showPhotoLibrary(withSender: self)
        actionSheet.selectImageBlock = { images, assets, isOrgin in
            if let location = assets.first?.location{
                let parameters = ["latlng" : "\(location.coordinate.latitude),\(location.coordinate.longitude)","key" : Constants.Google_Map_key]

                NetworkTools.requestData(type: .GET, URLString: Constants.Google_Map_Api, parameters:parameters, finishedCallback: { (result) in
                    print("result",result)
                })
                
            }
            
        }
 */
    }
    
    @objc func didSelectAddAction(button : UIButton) {
        let actionSheet = ZLPhotoActionSheet()
        actionSheet.configuration.maxSelectCount = 100
        actionSheet.configuration.allowTakePhotoInLibrary = false
        actionSheet.showPhotoLibrary(withSender: self)
        // 图片多选
        actionSheet.selectImageBlock = {[weak self] images,assets,isOrgin in
            if let weaskSelf = self{
                if let images = images{
                    weaskSelf.selectImages.append(images)
                    weaskSelf.sources.append(assets)
                    weaskSelf.chargeAssetsLocation(assets: assets, images: images)
                    weaskSelf.tableView.reloadData()
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (tableView.frame.size.width - 3) / 4, height: (tableView.frame.size.width - 3) / 4)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1

        let displayVC : OnePhotosVC = OnePhotosVC(collectionViewLayout: layout)
        
        displayVC.sources = sortWithDateString(dicts: self.allDict[indexPath.section])
        navigationController?.pushViewController(displayVC, animated: true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < allDict.count{
            let headerDicts = allDict[section]
            let countrysDict = headerDicts.filter { (dict) -> Bool in
                return dict["country"] != nil
            }
            let countryStrs = NSArray(array: countrysDict).value(forKey: "country") as! [String]
            
            let c_set = NSSet(array: countryStrs)
            let country = (c_set.allObjects as NSArray).componentsJoined(by: ",")
            
            return country
        }
        return nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sources.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PhtotsCell.self), for: indexPath) as! PhtotsCell
        
        
        // Configure the cell...
        cell.configureCell(image: self.selectImages[indexPath.section].first)
      
        return cell
    }
    
    // MARK: Photos charge
    
    func chargeAssetsLocation(assets : [PHAsset], images : [UIImage]){
        dicts = Array<Dictionary<String, Any>>()
        for asset in assets{
            let idx = assets.index(of: asset)
            var dict = Dictionary<String, Any>()
            dict["image"] = images[idx!]
            if let createDate = asset.creationDate{
                dict["createDate"] = createDate.dateFromString(dateStr: "YYYY-MM-dd")
            }
            getLocationCountry(asset: asset, dict: dict, res: {[weak self] country in
                if let w_self = self{
                    if w_self.dicts.filter({ (dict_f) -> Bool in
                        if let c = dict_f["country"]{
                            return (c as! String) != country
                        }
                        return true
                    }).count > 0
                    {
                        w_self.tableView.reloadData()
                    }
                    
                    dict["country"] = country
                    w_self.dicts.append(dict)
                    w_self.setAllDicts()
                }
            })
        }
    }
    
    func setAllDicts(){
        if allDict.count != sources.count{
            allDict.append(dicts)
        }
        else
        {
            allDict[sources.count - 1] = dicts
        }
        
    }
    
    func sortWithDateString(dicts : [Dictionary<String, Any>]) -> [[Dictionary<String, Any>]]{
        var sorts = [[Dictionary<String, Any>]]()
        let dates = NSArray(array: dicts).value(forKey: "createDate") as! [String]
        let dateSet = NSSet(array: dates)
        for dateStr in dateSet.allObjects{
            let createDateStr = String(describing: dateStr)
            let someArry =   dicts.filter({ (dict) -> Bool in
                return (dict["createDate"] as! NSString).isEqual(to: createDateStr)
            })
            sorts.append(someArry)
        }
        return sorts
    }
    
    func getLocationCountry(asset : PHAsset, dict : Dictionary<String, Any>,res: ((_ country : String) -> Void)?){
        if let location = asset.location{
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil, let placemark = placemarks?.first{
                    if let country = placemark.country{
                        if let res = res{
                            res(country)
                        }
                    }
                    else
                    {
                        self.dicts.append(dict)
                        self.setAllDicts()
                    }
                }
                else
                {
                    self.dicts.append(dict)
                    self.setAllDicts()
                }
            })
        }
        else
        {
            self.dicts.append(dict)
            self.setAllDicts()
        }
    }
    
    func getAllImages() -> NSMutableArray?{
        var allAssets = [PHAsset]()
        for assets in sources {
            for asset in assets{
                allAssets.append(asset)
            }
        }
        return NSMutableArray(array: allAssets)
    }
    
    func sortImagesWithDicts(dicts : Array<Dictionary<String , Any>>){
        NSLog("dicts %@", dicts)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension(Date){
    func dateFromString(dateStr : String) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = dateStr
        
        return dateFormatter.string(from: self)
    }
}

extension (Dictionary){
    func urlString() -> String{
        let someA : [String] = self.compactMap({ (key, value) -> String in
            
            return "\(key)=\(value)"
        })
        
        return someA.joined(separator: "&")
    }
}

