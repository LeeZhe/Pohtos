//
//  SuggestedTripVC.swift
//  PhotosCase
//
//  Created by Kiddie on 2018/4/15.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
var memories : [String : Array<PHAssetCollection>]?
var sources = [MemoryModel]()
class SuggestedTripVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        collectionView?.showsHorizontalScrollIndicator = false
        // Do any additional setup after loading the view.
        self.collectionView!.register(SuggestedTripCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.groupTableViewBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        var maxKey = PCPhotoManager.defaultManager.memoryAssets.keys.first
        var count = 0
        for (key , value) in PCPhotoManager.defaultManager.memoryAssets{
            if value.count > count{
                count = value.count
                maxKey = key
            }
        }
        
        PCPhotoManager.defaultManager.memoryAssets[maxKey!] = nil
        // Display lastest photos
        for (key, value) in PCPhotoManager.defaultManager.memoryAssets.enumerated().reversed(){
            
        }
        
        
        
        
//        collectionView?.register(ReuseHeaderView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReuseHeaderView")
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memories?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        return cell
    }
    
  
    // MARK: Flow lay out
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 30, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 15 * 5) / 2, height:(collectionView.width - 15 * 5) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

class SuggestedTripCell: UICollectionViewCell {
    var imgs = [UIImageView]()
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contrainView = UIView()
        contrainView.backgroundColor = UIColor.white
        contrainView.layer.cornerRadius = 5;
        contrainView.layer.masksToBounds = true;
        contentView.addSubview(contrainView)
        
        for x in [0,1,2,4]{
            let img = UIImageView()
            imgs.append(img)
            img.clipsToBounds = true
            img.contentMode = .scaleAspectFill
            img.backgroundColor = UIColor.red
            
//            let maskPath = UIBezierPath.init(roundedRect: <#T##CGRect#>, byRoundingCorners: <#T##UIRectCorner#>, cornerRadii: <#T##CGSize#>)
            
            contrainView.addSubview(img)
        }
        contrainView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        NSArray(array: contrainView.subviews).mas_distributeSudokuViews(withFixedLineSpacing: 1, fixedInteritemSpacing: 1, warpCount: 2, topSpacing: 0, bottomSpacing: 0, leadSpacing: 0, tailSpacing: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailSize = imgs.first?.frame.size
    }
    
    open func configureCell(assets : [PHAsset]){
        guard assets.count > 3 else {
            return;
        }
        for img in imgs{
            let idx = imgs.index(of: img)
            imageManager.requestImage(for: assets[idx!], targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
                    img.image = image
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
