//
//  TravePhotoSelVC.swift
//  PhotosCase
//
//  Created by Kiddie on 2018/4/15.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit
import Photos
class TravePhotoSelVC: UIViewController {
    var memories : [String : Array<PHAssetCollection>]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let headerView = HeaderView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.height)! + UIApplication.shared.statusBarFrame.size.height, width: view.width, height: 60))
        view.addSubview(headerView)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let suggestedChildVC = SuggestedTripVC(collectionViewLayout: layout)
        suggestedChildVC.view?.frame = CGRect(x: 0, y: (navigationController?.navigationBar.height)! + UIApplication.shared.statusBarFrame.size.height + 60, width: view.width, height: (view.width - 15 * 5) / 2 + 60)
        view.addSubview(suggestedChildVC.view)
        addChildViewController(suggestedChildVC)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class HeaderView : UIView{
    var textLabel : UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(textLabel)
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.text = "Suggested Trips"
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


