//
//  MapViewController.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  var businesses: [Business]?
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Location of San Francisco
    let friscoLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
    let span = MKCoordinateSpanMake(0.1, 0.1)
    let region = MKCoordinateRegionMake(friscoLocation.coordinate, span)
    mapView.setRegion(region, animated: false)
    mapView.addAnnotations(getAnnotations(forBusinesses: businesses!))
  }
  
  func getAnnotations(forBusinesses businesses: [Business]) -> [MKPointAnnotation] {
    var annotations = [MKPointAnnotation]()
    for business in businesses {
      if let latitude = business.latitude, let longitude = business.longitude {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = business.name ?? ""
        annotations.append(annotation)
      }
    }
    return annotations
  }
}
