//
//  SuggestedsTripImagesVC.swift
//  PhotosCase
//
//  Created by KiddieBao on 2018/4/29.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SuggestedsTripImagesVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var traves = [PHAssetCollection]()
    var assets = [[PHAsset]]()
    var m_model = MemoryModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(DisplayCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self

        collectionView?.register(ReuseHeaderView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReuseHeaderView")
        let date = m_model.startDate?.dateFromString(dateStr: "MM-dd,YYYY") ?? ""
        let endDate = m_model.endDate?.dateFromString(dateStr: "MM-dd,YYYY") ?? ""
        self.title = "\(date)-\(endDate)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return m_model.theOneAssets.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return m_model.theOneAssets[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DisplayCell
        // Configure the cell
        ZLPhotoManager.requestImage(for: m_model.theOneAssets[indexPath.section][indexPath.row], size: CGSize(width: (collectionView.frame.size.width - 3) / 4, height: (collectionView.frame.size.width - 3) / 4)) { (image, dict) in
            if let image = image{
                cell.img.image = image
            }
        }
        
        return cell
    }
    
    // MARK: UICollection view flow lay out delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width , height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 3) / 4, height: (collectionView.frame.size.width - 3) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReuseHeaderView", for: indexPath) as! ReuseHeaderView
        
        if m_model.places.count > indexPath.section{
            header.label.text = m_model.places[indexPath.section]
        }
        else
        {
            header.label.text = m_model.theOneAssets[indexPath.section].first?.localIdentifier
        }
        
//        if let date = headerDicts[indexPath.row]["createDate"]{
//            header.label.text = date as! String + " " + country
//        }
        return header
    }

}
