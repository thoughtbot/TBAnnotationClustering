//
//  TBCoordinateQuadTreeBuilder.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

class TBHotelCSVTreeBuilder {
    
    func buildTree(dataFileName:String, worldBounds:TBBoundingBox) -> TBQuadTreeNode {
        let data = getFileContent(dataFileName)
        let lines = data.componentsSeparatedByString("\n")
        
        var dataArray = [TBQuadTreeNodeData]()
        
        for line in lines {
            if line != "" {
                dataArray.append(dataFromLine(line))
            }
        }
        
        return TBQuadTreeNode(boundary: worldBounds, capacity: 4, dataArr: dataArray)
    }
    
    private func dataFromLine(line: NSString) -> TBQuadTreeNodeData {
        let components = line.componentsSeparatedByString(",")
        
        let latitude = Double(components[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!
        let longitude = Double(components[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!
        
        let hotelName = components[2].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let hotelPhoneNumber = components.last!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let hotelInfo = TBHotelInfo(hotelName: hotelName, hotelPhoneNumber: hotelPhoneNumber)
        
        return TBQuadTreeNodeData(x: latitude, y: longitude, data: hotelInfo)
    }
    
    private func getFileContent(fileName:String) -> String {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource(fileName, ofType: "csv")!
        var data = ""
        
        do {
            data = try String(contentsOfFile: path, encoding: NSASCIIStringEncoding)
        } catch {}
        
        return data
    }
}