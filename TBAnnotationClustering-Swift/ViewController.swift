//
//  ViewController.swift
//  TBAnnotationClustering-Swift
//
//  Created by Eyal Darshan on 1/1/16.
//  Copyright © 2016 eyaldar. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let TBAnnotatioViewReuseID = "TBAnnotatioViewReuseID"

    // DEFINE THE TREE'S BOUNDS:
    let world = TBBoundingBox(x: 19, y: -166, xf: 72, yf:-53)// x: 90, y: 180, xf: -90, yf: -180)
    
    let hotelTreeBuilder = TBHotelCSVTreeBuilder()
    var tbCoordinateQuadTree:TBCoordinateQuadTree?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        tbCoordinateQuadTree = TBCoordinateQuadTree(builder: hotelTreeBuilder, mapView: mapView)
        tbCoordinateQuadTree!.buildTree("USA-HotelMotel", worldBounds: world)
    }

    func updateMapViewAnnotations(annotations: [MKAnnotation]) {
        let before = NSMutableSet(array: self.mapView.annotations)
        let after = NSMutableSet(array: annotations)
        
        let toKeep = NSMutableSet(set: before)
        toKeep.intersectsSet(after as Set<NSObject>)
        
        let toAdd = NSMutableSet(set: after)
        toAdd.minusSet(toKeep as Set<NSObject>)
        
        let toRemove = NSMutableSet(set: before)
        toRemove.minusSet(after as Set<NSObject>)
        
        NSOperationQueue().addOperationWithBlock() {
            self.mapView.addAnnotations(toAdd.allObjects as! [MKAnnotation])
            self.mapView.removeAnnotations(toRemove.allObjects as! [MKAnnotation])
        }
    }
    
    func addBounceAnimationToView(view:UIView?) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        bounceAnimation.values = [0.05, 1.1, 0.9, 1]
        bounceAnimation.duration = 0.6
        
        var timingFunctions = [CAMediaTimingFunction]()
        
        for _ in 0..<4 {
            timingFunctions.append(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        }
        
        bounceAnimation.timingFunctions = timingFunctions
        bounceAnimation.removedOnCompletion = false
        
        view!.layer.addAnimation(bounceAnimation, forKey: "bounce")
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for view in views {
            addBounceAnimationToView(view)
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock() {
            let zoomScale = Double(self.mapView.bounds.size.width) / self.mapView.visibleMapRect.size.width
            let annotations = self.tbCoordinateQuadTree!.clusteredAnnotationWithinMapRect(mapView.visibleMapRect, zoomScale: MKZoomScale(zoomScale))
            
            self.updateMapViewAnnotations(annotations)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view:TBClusterAnnotationView?
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(TBAnnotatioViewReuseID) as? TBClusterAnnotationView {
            view = dequeuedView
        } else {
            view = TBClusterAnnotationView(annotation: annotation, reuseIdentifier: TBAnnotatioViewReuseID)
        }
        
        view?.canShowCallout = true
        
        if let annotation = annotation as? TBClusterAnnotation {
            view?.setCount(annotation.count)
        }
        
        return view
    }
}

