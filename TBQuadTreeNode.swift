//
//  TBQuadTreeNode.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import Foundation

class TBQuadTreeNode {
    var northWest:TBQuadTreeNode?
    var northEast:TBQuadTreeNode?
    var southWest:TBQuadTreeNode?
    var southEast:TBQuadTreeNode?
    var boundingBox:TBBoundingBox
    var bucketCapacity:Int
    var points = [TBQuadTreeNodeData]()
    
    init(boundary:TBBoundingBox, capacity:Int, dataArr:[TBQuadTreeNodeData]? = nil) {
        self.boundingBox = boundary
        self.bucketCapacity = capacity
        
        if let dataArr = dataArr {
            for data in dataArr {
                insertData(data)
            }
        }
    }
    
    var isLeaf: Bool {
        return (northWest == nil)
    }
    
    func subdivide() {
        let xMid = (boundingBox.xf + boundingBox.x0) / 2.0
        let yMid = (boundingBox.yf + boundingBox.y0) / 2.0
        
        let northWestBox = TBBoundingBox(x: boundingBox.x0, y: boundingBox.y0, xf: xMid, yf: yMid)
        northWest = TBQuadTreeNode(boundary: northWestBox, capacity: bucketCapacity)
        
        let northEastBox = TBBoundingBox(x: xMid, y: boundingBox.y0, xf: boundingBox.xf, yf: yMid)
        northEast = TBQuadTreeNode(boundary: northEastBox, capacity: bucketCapacity)
        
        let southWestBox = TBBoundingBox(x: boundingBox.x0, y: yMid, xf: xMid, yf: boundingBox.yf)
        southWest = TBQuadTreeNode(boundary: southWestBox, capacity: bucketCapacity)
        
        let southEastBox = TBBoundingBox(x: xMid, y: yMid, xf: boundingBox.xf, yf: boundingBox.yf)
        southEast = TBQuadTreeNode(boundary: southEastBox, capacity: bucketCapacity)
    }
    
    func insertData(data:TBQuadTreeNodeData) -> Bool {
        // Bail if our coordinate is not inside the boundingBox
        if !boundingBox.containsData(data) {
            return false
        }
        
        // Add the coordinate to the points array
        if points.count < bucketCapacity {
            points.append(data)
            return true
        }
        
        // Check to see if the current node is a leaf, in case it is, split
        if isLeaf {
            subdivide()
        }
        
        // Traverse the tree
        if northWest!.insertData(data) { return true }
        if northEast!.insertData(data) { return true }
        if southWest!.insertData(data) { return true }
        if southEast!.insertData(data) { return true }
        
        return false
    }
    
    func gatherDataInRange(range: TBBoundingBox, action: (TBQuadTreeNodeData) -> Void) {
        // If range is not contained in the node's boundingBox then bail
        if !boundingBox.intersectWith(range) {
            return
        }
        
        for point in points {
            if range.containsData(point) {
                action(point)
            }
        }
        
        // If node isn't leaf traverse down the tree
        if !isLeaf {
            northWest!.gatherDataInRange(range, action: action)
            northEast!.gatherDataInRange(range, action: action)
            southWest!.gatherDataInRange(range, action: action)
            southEast!.gatherDataInRange(range, action: action)
        }
    }
    
    func traverse(action: (TBQuadTreeNode) -> Void) {
        action(self)
        
        if !isLeaf {
            northWest!.traverse(action)
            northEast!.traverse(action)
            southWest!.traverse(action)
            southEast!.traverse(action)
        }
    }
    
    class func buildWithData(boundary:TBBoundingBox, bucketCapacity:Int) {
        
    }
}
