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
    var allCollections = [PHAssetCollection]()
    var residence : String!
    var traves = [[PHAssetCollection]]()
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
                self.allCollections.append(object)
            }
            
        }
        
        // The max count of the array is place of residence
        choosePlaceOfResidence()
        organizeTravel()
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
        if let maxKey = maxKey{
            memories[maxKey] =  nil
            self.residence = maxKey
        }
        
//        memories.removeAll()
    }
    
    private func organizeTravel(){
       self.allCollections = self.allCollections.filter { (collection) -> Bool in
        if let place = collection.localizedTitle?.split(separator: " ").first{
                return place != self.residence
            }
            return true
        }
        var  collections = Array(allCollections)
        for collection in self.allCollections{
            if let startDate = collection.startDate{
                let theOneTraves = collections.filter { (c_model) -> Bool in
                    
                    if let c_starDate = c_model.startDate{
                        return abs(Int32(c_starDate.timeIntervalSince(startDate))) <= 5 * 86400
                    }
                    
                    return false
                }
                
                for place in theOneTraves{
                   let idx = collections.index(of: place)
                    if idx != nil{
                        collections.remove(at: idx!)
                    }
                }
                
                if theOneTraves.count > 0{
                    traves.append(theOneTraves)
                }
                
            }
        }
        // print the organized trave
        for trave in traves{
            let array = NSArray(array: trave)
            print(array.value(forKey: "localizedTitle"))
            print(array.value(forKey: "startDate"))
        }
        
        if traves.count > 7{
            traves.removeSubrange(traves.count - 7..<traves.count - 1)
        }
    }
 
}
