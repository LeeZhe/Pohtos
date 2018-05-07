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

                if let _  = self.memories[place]{
                    self.memories[place]?.append(object)
                }
                else
                {
                    self.memories[place] = [object]
                }
            }
            else if let _ = object.approximateLocation
            {
                self.allCollections.append(object);
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
            
            guard collections.count == 1 else{
                return true
            }
            
            for i in 0..<collections.count - 1{
                guard (collections[i].startDate?.timeIntervalSince(collections[i + 1].startDate!))! < 7 * 24 * 3600 else {
                    return false
                }
            }
            return true
        }
        
        var allValues = [PHAssetCollection]()
        for collections in placeMoments.values{
            for collection in collections{
                
                collection.distanceResicence = (collection.approximateLocation?.distance(from: self.localLacation))!
                
                
                guard collection.distanceResicence > 30 * 1000, collection.estimatedAssetCount > 10 else{
                    continue
                }
                allValues.append(collection)
            }
        }
        
        for collection in self.allCollections{
            if let location = collection.approximateLocation{
                collection.distanceResicence = location.distance(from: self.localLacation)
                guard collection.distanceResicence > 30 * 1000 , collection.estimatedAssetCount > 10 else{
                    continue
                }
                allValues.append(collection)
            }
        }
        
        
        allValues.sort { (col1, col2) -> Bool in
            return col1.startDate! < col2.startDate!
        }
        
        var count = 0
        while true{
            var theOneTrave = [PHAssetCollection]()
            for i in 0..<allValues.count{
                
                guard fabs(allValues.first!.distanceResicence / allValues[i].distanceResicence  - 1) < 0.15 ,
                    Calendar.current.dateComponents([.day], from: (allValues.first?.startDate!)!, to: allValues[i].endDate!).day! < 7 else
                {
                    allValues.removeSubrange(0..<theOneTrave.count)
                    
                    if let endDate = self.traves.last?.last?.endDate, let startDate = theOneTrave.first?.startDate{
                        
                        guard Calendar.current.dateComponents([.day], from: endDate, to: startDate).day! > 1 else {
                            self.traves[self.traves.count - 1].append(contentsOf: theOneTrave)
                            break
                        }
                        
                    }
                    
                    self.traves.append(theOneTrave)
                    break;
                }
                theOneTrave.append(allValues[i])
            }
            
            guard count != allValues.count else{
                self.traves.append(theOneTrave)
                break
            }
            
            count = allValues.count
        }
        
        for trave in traves{
            let array = NSArray(array: trave)
            print(array.value(forKey: "localizedTitle"))
            print(array.value(forKey: "startDate"))
        }
        
        self.traves = self.traves.sorted(by: { (col1, col2) -> Bool in
            return (col1.first?.startDate)! <  (col2.first?.startDate)!
        })
        
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
