//
//  SwitchCell.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

enum cellIconType: String {
  case check = "Check"
  case uncheck = "Uncheck"
  case dropdown = "Dropdown"
}

@objc protocol SwitchCellDelegate {
  @objc optional func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
  
  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var onSwitch: UISwitch!
  @IBOutlet weak var switchImage: UIImageView!
  
  weak var delegate: SwitchCellDelegate?
  
  var iconType: cellIconType? {
    didSet{
      if let iconType = iconType {
        switch iconType {
        case .check :
          switchImage.image = UIImage(named: "Check")
        case .uncheck :
          switchImage.image = UIImage(named: "Uncheck")
        case .dropdown :
          switchImage.image = UIImage(named: "Dropdown")
        }
      } else {
        switchImage.image = nil
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // hook to UI switch programatically, add target
    onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
  }
  
  // action for the UI switch
  func switchValueChanged() {
    //print("switch value changed")
    delegate?.switchCell?(self, didChangeValue: onSwitch.isOn)
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
