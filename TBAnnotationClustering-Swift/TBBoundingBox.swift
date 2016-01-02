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

    private let height:Double
    private let width:Double
    private let centerX:Double
    private let centerY:Double
    
    init(x:Double, y:Double, xf:Double, yf:Double) {
        self.x0 = x
        self.y0 = y
        self.xf = xf
        self.yf = yf
        
        height = abs(yf - y0)
        width = abs(xf - x0)
        centerX = x0 + (width / 2)
        centerY = y0 + (height / 2)
    }
    
    func containsData(data:TBQuadTreeNodeData) -> Bool {
        let containsX = x0 <= data.x && data.x <= xf
        let containsY = y0 <= data.y && data.y <= yf
        
        return containsX && containsY
    }
    
    func intersectWith(other:TBBoundingBox) -> Bool {
        let intersectsX = abs(centerX - other.centerX) * 2 < (width + other.width)
        let intersectsY = abs(centerY - other.centerY) * 2 < (height + other.height)
        return intersectsX && intersectsY
    }
}
