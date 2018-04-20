//
//  PCPhotoManager.swift
//  PhotosCase
//
//  Created by Kiddie on 2018/4/15.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit
import ZLPhotoBrowser
class PCPhotoManager: ZLPhotoManager {
    static let defaultManager = PCPhotoManager()
    
    private override init() {
        super.init()
    }
    
    var memories = [String: Array<PHAssetCollection>]()
    var memoryAssets = [String : Array<PHFetchResult<PHAsset>>]()
    open func getMoments(){
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let momentAlbums = PHAssetCollection.fetchMoments(with: options)
        
        momentAlbums.enumerateObjects(options: .concurrent) { (object,
            idx,
            stop: UnsafeMutablePointer<ObjCBool>)  in
            
            // Find the moment where has title
            if let place = object.localizedTitle?.split(separator: " ").first{
                let placeStr = String(place)
                if let _ = self.memories[placeStr]{
                    self.memories[placeStr]?.append(object)
                }
                else
                {
                    self.memories[placeStr] = [object]
                }
            }
        }
        
        // The max count of the array is place of residence
    }
    
    private func choosePlaceOfResidence(){
        var maxCount = 0
        var maxKey = memories.keys.first
        for (key , collections) in memories{
            if collections.count > maxCount{
                maxCount = collections.count
                maxKey = key
            }
        }
        memories[maxKey!] =  nil
    }
    
    private func organizeTravel(){
        for (key , collections) in memories{
            for collection in collections{
                
            }
        }
    }
 
}
