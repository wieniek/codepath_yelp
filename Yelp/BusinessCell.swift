//
//  BusinessCell.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
  
  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var ratingImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var reviewsCountLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  
  var business: Business! {
    didSet {
      nameLabel.text = business.name ?? ""
      if let url = business.imageURL {
        thumbImageView.setImageWith(url)
      }
      if let url = business.ratingImageURL {
        ratingImageView.setImageWith(url)
      }
      distanceLabel.text = business.distance ?? ""
      reviewsCountLabel.text = "\(business.reviewCount ?? 0) Reviews"
      addressLabel.text = business.address ?? ""
      categoryLabel.text = business.categories ?? ""
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    thumbImageView.layer.cornerRadius = 3
    thumbImageView.clipsToBounds = true
    // No color when the user selects cell
    selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
