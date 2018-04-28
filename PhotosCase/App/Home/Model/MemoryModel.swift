//
//  MemoryModel.swift
//  PhotosCase
//
//  Created by Kiddie on 2018/4/15.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit

class MemoryModel: NSObject {
//    @objc var createDate : String?
    @objc var places = [String]()
    @objc var images : [UIImage]?
    @objc var localizedLocationNames = [[String]]()
    @objc var theOneAssets = [[PHAsset]]()
    @objc var allAssets = [PHAsset]()
    @objc var startDate : Date?
    @objc var endDate : Date?
    @objc var displayAssets = [PHAsset]()
    @objc var displayImages = [UIImage]()
    
    
    func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        print(Int(y))
        return Int(y)
    }
}
