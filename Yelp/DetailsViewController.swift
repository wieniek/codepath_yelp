//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  @IBOutlet weak var reviewsLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingImage: UIImageView!
  
  @IBOutlet weak var mapView: MKMapView!
  
  
  var business: Business?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set business details
    nameLabel.text = business?.name ?? ""
    addressLabel.text = business?.address ?? ""
    categoriesLabel.text = business?.categories ?? ""
    reviewsLabel.text = "\(business?.reviewCount ?? 0) Reviews"
    distanceLabel.text = business?.distance ?? ""
    if let url = business?.ratingImageURL {
      ratingImage.setImageWith(url)
    }
    
    // set map location and add annotation
    if let latitude = business?.latitude, let longitude = business?.longitude {
      let businessLocation = CLLocation(latitude: latitude, longitude: longitude)
      let span = MKCoordinateSpanMake(0.03, 0.03)
      let region = MKCoordinateRegionMake(businessLocation.coordinate, span)
      mapView.setRegion(region, animated: false)
      let annotation = MKPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      annotation.title = business?.name ?? ""
      mapView.addAnnotation(annotation)
    }
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
