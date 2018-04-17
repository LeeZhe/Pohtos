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
            
            if let location = object.approximateLocation{
                
                let geo = CLGeocoder()
                geo.reverseGeocodeLocation(location, completionHandler: { (places, error) in
                    

                    if error != nil{
                        print(object.localizedTitle ?? "has none localizedTitle")
                        print(error?.localizedDescription)
                    }
                    
                    if let place = places?.first{
                        if place.country != nil && place.locality != nil{
                            let key = place.country! + " " + place.locality!
                            print(key)
                            
                            
                            let assets = PHAsset.fetchKeyAssets(in: object, options: nil)
                            
                            if let assets = assets {
                                if self.memoryAssets[key] == nil{
                                    self.memoryAssets[key] = [assets]
                                }
                                else
                                {
                                    self.memoryAssets[key]?.append(assets)
                                }

                            }
                            
                            if self.memories[key] == nil{
                                self.memories[key] = [object]
                            }
                            else
                            {
                                self.memories[key]?.append(object)
                            }
                        } else
                        {
                            print(place.subLocality ?? "",place.administrativeArea ?? "",place.subAdministrativeArea ?? "",
                                  place.areasOfInterest ?? "")
                            /*
                            let key = place.subAdministrativeArea ?? "" + " " + place.locality! ?? ""
                            
                            let assets = PHAsset.fetchKeyAssets(in: object, options: nil)
                            
                            if let assets = assets {
                                if self.memoryAssets[key] == nil{
                                    self.memoryAssets[key] = [assets]
                                }
                                else
                                {
                                    self.memoryAssets[key]?.append(assets)
                                }
                                
                            }
                            
                            if self.memories[key] == nil{
                                self.memories[key] = [object]
                            }
                            else
                            {
                                self.memories[key]?.append(object)
                            }
                         */
                        }
                    }
                })
            }
            else{
                if object.localizedLocationNames.count > 0{
                    print(object.localizedLocationNames)
                }
//                if let
            }
            /*
             else
             {
             print("has none location",object.localizedTitle ?? "",object.startDate?.dateFromString(dateStr: "YYYY-MM-dd"))
             let assets = PHAsset.fetchAssets(in: object, options: nil)
             assets.enumerateObjects({ (asset, idx, stop: UnsafeMutablePointer<ObjCBool>) in
             if let location = asset.location{
             print("None location has asset location")
             }
             })
             }
             
             }
             
             }
             */
        }
    }       
}
