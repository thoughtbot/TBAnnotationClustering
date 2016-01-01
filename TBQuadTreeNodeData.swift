//
//  TBQuadTreeNodeData.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

struct TBQuadTreeNodeData {
    let x:Double
    let y:Double
    let data:AnyObject
    
    init(x:Double, y:Double, data:AnyObject) {
        self.x = x
        self.y = y
        self.data = data
    }
}
