//
//  SuggestedTripVC.swift
//  PhotosCase
//
//  Created by Kiddie on 2018/4/15.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SuggestedTripVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var memories : [String : Array<PHAssetCollection>]?
    var sources = [MemoryModel]()
    var travels = [[PHAssetCollection]]()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        collectionView?.showsHorizontalScrollIndicator = false
        // Do any additional setup after loading the view.
        collectionView?.register(SuggestedTripCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.groupTableViewBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
//        collectionView?.register(ReuseHeaderView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReuseHeaderView")
        travels = PCPhotoManager.defaultManager.traves
        
        
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        for trave in travels
        {
            
            
            let m_model = MemoryModel()
            
            m_model.startDate = trave.first?.startDate
            m_model.endDate = trave.last?.endDate
            
            for collection in  trave{
                print(collection.localizedTitle ?? "")
                
                if let localizedTitle = collection.localizedTitle{
                    if m_model.places.contains(localizedTitle) == false{
                        m_model.places.append(localizedTitle.split(separator: "-").joined())
                    }
                }
                
                if collection.localizedLocationNames.count > 0{
                    m_model.localizedLocationNames.append(collection.localizedLocationNames)
                }
                
                var assets = [PHAsset]()
                let results = PHAsset.fetchAssets(in: collection, options: options)
                results.enumerateObjects { (asset, idx, _) in
                    m_model.allAssets.append(asset)
                    assets.append(asset)
                }
                m_model.theOneAssets.append(assets)
                
            }
            
            // random asset in the one assets and filter the count < 4
            if m_model.allAssets.count > 4{
                
//                m_model.displayAssets = m_model.allAssets
                for idx in 0 ..< 4{
                    m_model.displayAssets.append(m_model.allAssets[idx])
                }
                
                ZLPhotoManager.anialysisAssets(m_model.displayAssets, original: false) { (images) in
                    if let images = images{
                        self.sources.append(m_model)
                        m_model.displayImages = images
                        let indexPath = IndexPath.init(row: self.sources.count - 1, section: 0)
                        self.collectionView?.insertItems(at: [indexPath])
                    }
                }
            }
            
        }
        
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
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (collectionView.frame.size.width - 3) / 4, height: (collectionView.frame.size.width - 3) / 4)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            let sugVC = SuggestedsTripImagesVC(collectionViewLayout: layout)
            sugVC.m_model = self.sources[indexPath.row]
            sugVC.travels = self.travels[indexPath.row]
            navigationController?.pushViewController(sugVC, animated: true)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.sources.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SuggestedTripCell
        
        cell.configureCell(m_model: self.sources[indexPath.row])
        // Configure the cell
        return cell
    }
    
  
    // MARK: Flow lay out
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 30, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 15 * 5) / 2, height:(collectionView.width - 15 * 5) / 2 + 30)
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
    
    var label = UILabel()
    var timeLb = UILabel()
    var picNo = UILabel()
//    var cacheImages = [UIImage]()
//    fileprivate let imageManager = PHCachingImageManager()
//    fileprivate var thumbnailSize: CGSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contrainView = UIView()
        contrainView.backgroundColor = UIColor.white
        contrainView.layer.cornerRadius = 5;
        contrainView.layer.masksToBounds = true;
        contentView.addSubview(contrainView)
        
        for _ in 0..<4{
            let img = UIImageView()
            imgs.append(img)
            img.clipsToBounds = true
            img.contentMode = .scaleAspectFill
//            img.backgroundColor = UIColor.red
            
//            let maskPath = UIBezierPath.init(roundedRect: <#T##CGRect#>, byRoundingCorners: <#T##UIRectCorner#>, cornerRadii: <#T##CGSize#>)
            
            contrainView.addSubview(img)
        }
        contrainView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 30, 0));
        }
        
        NSArray(array: contrainView.subviews).mas_distributeSudokuViews(withFixedLineSpacing: 1, fixedInteritemSpacing: 1, warpCount: 2, topSpacing: 0, bottomSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        
//        let titleView = UIView()
//        titleView.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
//        titleView.layer.cornerRadius = 5.0
//        contentView.addSubview(titleView)
//        titleView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIEdgeInsetsMake(50, 15, 50, 15));
//        }
        
        contrainView.addSubview(label)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true;
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.lineBreakMode = .byClipping
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        self.label.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(30, 12, 30, 12));
        }
        
        addSubview(timeLb)
        timeLb.font = UIFont.systemFont(ofSize: 14)
        timeLb.textColor = UIColor.gray
        timeLb.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(17)

        }
        
                addSubview(picNo)
        picNo.textColor = UIColor.gray
        picNo.font = timeLb.font
        picNo.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.timeLb)
            make.height.equalTo(17)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        thumbnailSize = imgs.first?.frame.size
    }
    
    open func configureCell(m_model : MemoryModel){
        guard  m_model.displayImages.count > 3 else {
            return
        }
        for (idx , imageView) in self.imgs.enumerated(){
            imageView.image = m_model.displayImages[idx]
        }
        
        if m_model.places.count > 2 {
            self.label.text = m_model.places[0..<2].joined(separator: "\n")
        }
        else
        {
            self.label.text = m_model.places.joined(separator: "\n")
        }
        
        if self.label.text?.count == nil{
            self.label.text = m_model.localizedLocationNames.first?.joined(separator: ",")
        }
        
        self.timeLb.text = m_model.startDate?.dateFromString(dateStr: "MMM-dd,yyyy")
        self.picNo.text = "No." + String(m_model.allAssets.count)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
