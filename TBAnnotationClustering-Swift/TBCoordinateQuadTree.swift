//
//  File.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation
import MapKit

class TBCoordinateQuadTree : NSObject {
    
    weak var mapView: MKMapView!
    let hotelTreeBuilder:TBHotelCSVTreeBuilder
    private var root:TBQuadTreeNode?
    
    init(builder:TBHotelCSVTreeBuilder, mapView: MKMapView) {
        self.hotelTreeBuilder = builder
        self.mapView = mapView
    }
    
    func buildTree(dataFileName:String, worldBounds:TBBoundingBox) {
        root = hotelTreeBuilder.buildTree(dataFileName, worldBounds: worldBounds)
    }
    
    func clusteredAnnotationWithinMapRect(rect:MKMapRect, zoomScale:MKZoomScale) -> [TBClusterAnnotation] {
        let tbCellSize = TBCellSizeForZoomScale(zoomScale)
        let zoomScaleDouble = Double(zoomScale)
        let scaleFactor = zoomScaleDouble / tbCellSize
        
        let minX = floor(MKMapRectGetMinX(rect) * scaleFactor)
        let maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor)
        let minY = floor(MKMapRectGetMinY(rect) * scaleFactor)
        let maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor)
        
        var clusteredAnnotations = [TBClusterAnnotation]()
        
        for var x:Double = minX; x <= maxX; x++ {
            for var y:Double = minY; y <= maxY; y++ {
                let mapRect = MKMapRectMake(x/scaleFactor, y/scaleFactor, 1.0/scaleFactor, 1.0/scaleFactor)
                
                var totalX = 0.0
                var totalY = 0.0
                
                var names = [String]()
                var phoneNumbers = [String]()
                
                root?.gatherDataInRange(getBoundingBox(mapRect), action: { (data) -> Void in
                    totalX += data.x
                    totalY += data.y
                    
                    let hotelInfo = data.data
                    names.append(hotelInfo.name)
                    
                    if let phoneNum = hotelInfo.phoneNumber! {
                        phoneNumbers.append(phoneNum)
                    }
                })
                
                let count = names.count
                
                if count > 1 {
                    let coordinate = CLLocationCoordinate2D(latitude: totalX / Double(count), longitude: totalY / Double(count))
                    let annotation = TBClusterAnnotation(coordinate: coordinate, count: count)
                    clusteredAnnotations.append(annotation)
                }
                
                if count > 1 {
                    let coordinate = CLLocationCoordinate2D(latitude: totalX, longitude: totalY)
                    let annotation = TBClusterAnnotation(coordinate: coordinate, count: count)
                    annotation.title = names.last!
                    annotation.subtitle = phoneNumbers.last!
                    clusteredAnnotations.append(annotation)
                }
            }
        }
        
        return clusteredAnnotations
    }
    
    func getBoundingBox(mapRect:MKMapRect) -> TBBoundingBox {
        let topLeft = MKCoordinateForMapPoint(mapRect.origin)
        let bottomRight = MKCoordinateForMapPoint(MKMapPoint(x: MKMapRectGetMaxX(mapRect), y: MKMapRectGetMaxY(mapRect)))
        
        let minLat = bottomRight.latitude
        let maxLat = topLeft.latitude
        
        let minLong = topLeft.longitude
        let maxLong = bottomRight.longitude
        
        return TBBoundingBox(x: minLat, y: minLong, xf: maxLat, yf: maxLong)
    }
    
    func TBZoomScaleToZoomLevel(scale:MKZoomScale) -> Double {
        let totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
        let zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
        let zoomLevel = max(0, zoomLevelAtMaxZoom + floor(log2(Double(scale)) + 0.5));
    
        return zoomLevel;
    }
    
    func TBCellSizeForZoomScale(zoomScale:MKZoomScale) -> Double {
        let zoomLevel = TBZoomScaleToZoomLevel(zoomScale);
        
        switch (zoomLevel) {
            case 13, 14, 15:
                return 64
            case 16, 17, 18:
                return 32
            case 19:
                return 16
            default:
                return 88
        }
    }
}
