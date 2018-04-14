//
//  GooglePlace.swift
//  PhotosCase
//
//  Created by KiddieBao on 2018/4/11.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit

class GooglePlace: NSObject {
    @objc var address_components : [PlaceDes] = []
    @objc var formatted_address : String?
    @objc var place_id : String?
//    @objc var geometry : Dictionary<String : Any>
    @objc var types : [String]?
}

class PlaceDes: NSObject {
    @objc var long_name : String?
    @objc var short_name : String?
    @objc var types : [String]?
}


