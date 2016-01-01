//
//  TBHotelInfo.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

class TBHotelInfo : NSObject{
    let hotelName:String
    let hotelPhoneNumber:String
    
    init(hotelName:String, hotelPhoneNumber:String) {
        self.hotelName = hotelName
        self.hotelPhoneNumber = hotelPhoneNumber
    }
}