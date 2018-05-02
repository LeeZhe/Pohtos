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
    var localLacation : CLLocation!
    var traves = [[PHAssetCollection]]()
    open func getMoments(){
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let momentAlbums = PHAssetCollection.fetchMoments(with: options)
        
        momentAlbums.enumerateObjects(options: .concurrent) { (object,
            idx,
            stop: UnsafeMutablePointer<ObjCBool>)  in
            
            // Find the moment where has title
            if let place = object.localizedTitle{
//                print(place)
//                print("startDate: \(object.startDate!.dateFromString(dateStr: "YYYY-MM-dd"))")
//                print("endDate: \(object.endDate!.dateFromString(dateStr: "YYYY-MM-dd"))")
                if let _ = self.memories[place]{
                    self.memories[place]?.append(object)
                }
                else
                {
                    self.memories[place] = [object]
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
            self.residence = maxKey
            for collection in memories[maxKey]!{
                if let location = collection.approximateLocation{
                    self.localLacation = location
                }
            }
            memories[maxKey] =  nil
        }
    }
    
    private func organizeTravel(){
        var placeMoments = [String : [PHAssetCollection]]()
        for (key,collections) in memories{
            guard collections.count <= 10 , collections.count > 0 else{
                continue
            }
            
            placeMoments[key] = collections
        }
        
        
        
        // Filter the date continuous
        placeMoments = placeMoments.filter { (arg) -> Bool in
            
            let (_, collections) = arg
            let isSec = abs(Int32((collections.first?.startDate?.timeIntervalSince((collections.last?.startDate)!))!)) < 8 * 24 * 3600
            
            return isSec
        }
        var allValues = [PHAssetCollection]()
        var tempValues = [PHAssetCollection]()
        for collections in placeMoments.values{
            for collection in collections{
                allValues.append(collection)
                tempValues.append(collection)
            }
        }
        
//        for collection in 
        
        
        
        
        for (_, collections) in placeMoments{
            
            for collection in collections{
                if let location = collection.approximateLocation{
                    collection.distanceResicence = location.distance(from: self.localLacation)
                }
            }
            
        }
        
        self.traves.sort { (collectionsOne, collectionsTwo) -> Bool in
            return collectionsOne.first!.distanceResicence < collectionsTwo.first!.distanceResicence
        }
        
//       self.traves = self.traves.filter { (collections) -> Bool in
//        if let startDate =  collections.first?.startDate, let location = collections.first?.approximateLocation{
//
//            }
//            re
//        }
        
        // print the organized trave
        if traves.count > 5{
            traves.removeSubrange(0..<traves.count - 5)
        }
        
        // print the organized trave
        for trave in traves{
            let array = NSArray(array: trave)
            print(array.value(forKey: "localizedTitle"))
            print(array.value(forKey: "startDate"))
        }

    }
}

extension PHCollection{
    private struct AssociateKeys{
        static var distanceKey = "DISTANCE"
    }
    
    open var distanceResicence : Double{ //Distance from residence location
        get{
            return objc_getAssociatedObject(self, &AssociateKeys.distanceKey) as! Double
        }
        set{
            objc_setAssociatedObject(self, &AssociateKeys.distanceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
