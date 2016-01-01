//
//  TBClusterAllocation.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import MapKit

class TBClusterAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let count:Int

    var title:String?
    var subtitle:String?
    
    init(coordinate:CLLocationCoordinate2D, count:Int) {
        self.coordinate = coordinate
        self.title = "\(count) hotels in this area"
        self.count = count
        
        super.init()
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? TBClusterAnnotation {
            return coordinate.longitude == other.coordinate.longitude &&
                    coordinate.latitude == other.coordinate.latitude
        }
        
        return false
    }
}
