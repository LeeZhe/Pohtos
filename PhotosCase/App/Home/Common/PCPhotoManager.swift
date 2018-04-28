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
    var filePath = ""
    private override init() {
        super.init()
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let cacheDirection = path! + "/Kiddie/\(Bundle.main.bundleIdentifier ?? "")"
        filePath = cacheDirection
        if !FileManager.default.fileExists(atPath: cacheDirection){
            try? FileManager.default.createDirectory(atPath: cacheDirection, withIntermediateDirectories: true, attributes: nil)
        }
        else
        {
            if FileManager.default.fileExists(atPath: filePath + "/place.plist"){
                self.datePlace = NSDictionary.init(contentsOfFile: "\(filePath)/place.plist") as! [String : String]
                
            }
        }
        
    }
    
    var memories = [String: Array<PHAssetCollection>]()
    var allCollections = [PHAssetCollection]()
    var residence : String!
    var traves = [[PHAssetCollection]]()
    var datePlace = [String : String]()
    open func getMoments(){
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        let momentAlbums = PHAssetCollection.fetchMoments(with: options)
        
        momentAlbums.enumerateObjects(options: .concurrent) { (object,
            idx,
            stop: UnsafeMutablePointer<ObjCBool>)  in
            
            // Find the moment where has location
            if let _ = object.approximateLocation{
                self.allCollections.append(object)
            }
            
        }
        
        let geo = CLGeocoder()
        dispathTimer(timeInterval: 0.15, repeatCount: self.allCollections.count, handler: { (_, idx) in
            let moment = self.allCollections[idx]
            
            if let startDate = moment.startDate{
                let dateStr = startDate.dateFromString(dateStr: "YYYY-MM-dd")
                if let key = self.datePlace[dateStr]{
                    print("cache has key \(key)")
                    if self.memories[key] == nil{
                        self.memories[key] = [moment]
                    }
                    else
                    {
                        self.memories[key]?.append(moment)
                    }
                }
                else
                {
                    
                    if let place = moment.approximateLocation{
                        geo.reverseGeocodeLocation(place, completionHandler: { (places, error) in
                            if error == nil{
                                var key = ""
                                if let city = places?.first?.locality{
                                    key = "\(places?.first?.country ?? "") \(city)"
                                }
                                else
                                {
                                    if let administrativeArea = places?.first?.administrativeArea{
                                        key = "\(places?.first?.country ?? "") \(administrativeArea)"
                                    }
                                }
                                
                                if let startDate = moment.startDate{
                                    print("None cache key \(key)")
                                    self.datePlace[startDate.dateFromString(dateStr: "YYYY-MM-dd")] = key
                                }
                                
                                if self.memories[key] == nil{
                                    self.memories[key] = [moment]
                                }
                                else
                                {
                                    self.memories[key]?.append(moment)
                                }
                            }
                            else
                            {
                                print(error?.localizedDescription ?? "None locatication")
                                
                            }
                            
                        })
                    }
                    
                    
                }
                
            }
            
        }) {
            if NSDictionary(dictionary: self.datePlace).write(toFile: "\(self.filePath)/place.plst", atomically: true){
                print("write to file success")
            }
            self.choosePlaceOfResidence()
            self.organizeTravel()
        }
        
        // The max count of the array is place of residence
//        choosePlaceOfResidence()

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
    }
    
    private func organizeTravel(){
       self.allCollections = self.allCollections.filter { (collection) -> Bool in
        if let starDate = collection.startDate?.dateFromString(dateStr: "YYYY-MM-dd"){
            if let placeCache = self.datePlace[starDate], placeCache == self.residence{
                    return false
            }
            
            if let place = collection.localizedTitle, let city = self.residence.components(separatedBy:" ").last{
                return !place.contains(city)
            }
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
            traves.removeSubrange(0..<traves.count - 7)
        }
        
        for trave in traves{
            let array = NSArray(array: trave)
            print(array.value(forKey: "localizedTitle"))
            print(array.value(forKey: "startDate"))
        }

    }
    
    public func dispathTimer(timeInterval : Double, repeatCount: Int, handler:@escaping (DispatchSourceTimer?, Int)->(), handlerCancle:@escaping() -> ())
    {
        if repeatCount <= 0 {
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        var count = repeatCount
        var index = 0
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.global().async {
                handler(timer, count)
                index += 1
            }
            if count == 0 {
                
                DispatchQueue.main.async {
                    timer.cancel()
                    handlerCancle()
                }
            }
        })
        timer.resume()
    }
}
