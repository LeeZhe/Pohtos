//
//  PhotosSelectVC.swift
//  Photos
//
//  Created by KiddieBao on 2018/3/30.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit
import ZLPhotoBrowser
import Photos
import CoreLocation

class PhotosSelectVC: UITableViewController {
    var sources = Array<Array<PHAsset>>()
    var selectImages = Array<Array<UIImage>>()
    var dicts = Array<Dictionary<String , Any>>()
//    var
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(PhtotsCell.self, forCellReuseIdentifier: NSStringFromClass(PhtotsCell.self))
        tableView.separatorStyle = .none
        
        someTestBlock { (text) in
            
        }
    }
    
    func someTestBlock(mactFuction : (_ text : String) -> Void){
        mactFuction("123")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 0 else {
            return
        }
    }
    
    func chargeAssetsLocation(assets : [PHAsset], images : [UIImage], completion: @escaping (_ dicts : Array<Dictionary<String, Any>>) -> Void){
        
        
        DispatchQueue.global().async {
            var dicts = Array<Dictionary<String, Any>>()
            
            for image in images{
                dicts.append(["image" : image])
            }
            
            for asset in assets{
                
                if let creationDate = asset.creationDate{
                    let createDate = creationDate.dateFromString(dateStr: "YYYY-MM-dd")
                    let idx = assets.index(of: asset)!
                    dicts[idx]["creationDate"] = createDate
                }
                
                if let location = asset.location {
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) in
                        if let placemark = placemarks?.first{
                            if let country = placemark.country{
                                let idx = assets.index(of: asset)!
                                dicts[idx]["country"] = country
                                completion(dicts)
                            }
                        }
                    })
                }
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : view.frame.size.width
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : selectImages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PhtotsCell.self), for: indexPath) as! PhtotsCell
        
        
        // Configure the cell...
        configureCell(cell, indexPath)
      
        return cell
    }
    
    func configureCell(_ cell : PhtotsCell, _ indexPath : IndexPath) {
        cell.didSelctAddButton = { [weak self] button -> Void in
            let actionSheet = ZLPhotoActionSheet()
            actionSheet.configuration.maxSelectCount = 100
            actionSheet.configuration.allowTakePhotoInLibrary = false
            
            if let weakSelf = self{
                actionSheet.arrSelectedAssets = weakSelf.getAllImages()
                actionSheet.showPhotoLibrary(withSender: weakSelf)
            }
            // 图片多选
            actionSheet.selectImageBlock = {[weak self] images,assets,isOrgin in
                if let weaskSelf = self{
                    if let images = images{
                        weaskSelf.selectImages.append(images)
                        weaskSelf.sources.append(assets)
                        
                        // 图片处理事务
                        weaskSelf.chargeAssetsLocation(assets: assets, images: images, completion: { [weak self] dicts in
                            if let w_self = self{
                                w_self.sortImagesWithDicts(dicts: dicts)
                            }
                        })
                        
                        weaskSelf.tableView.reloadData()
                    }
                }
            }
        }
        
        guard indexPath.section > 0 else{
            cell.congureCell(indexPath: indexPath, image: nil)
            return
        }
        
        cell.congureCell(indexPath: indexPath, image: self.selectImages[indexPath.row].first)
        
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


