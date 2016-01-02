//
//  TBBoundingBox.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

struct TBBoundingBox {
    let x0:Double
    let y0:Double
    let xf:Double
    let yf:Double
    
    init(x:Double, y:Double, xf:Double, yf:Double) {
        self.x0 = x
        self.y0 = y
        self.xf = xf
        self.yf = yf
    }
    
    func containsData(data:TBQuadTreeNodeData) -> Bool {
        let containsX = x0 <= data.x && data.x <= xf
        let containsY = y0 <= data.y && data.y <= yf
        
        return containsX && containsY
    }
    
    func intersectWith(other:TBBoundingBox) -> Bool {
        return x0 <= other.xf && xf >= other.x0 && y0 <= other.yf && yf >= other.y0
    }
}
