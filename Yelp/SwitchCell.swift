//
//  SwitchCell.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import SevenSwitch

enum cellType {
  case checkmark
  case onswitch
}

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
  @IBOutlet weak var switchImage: UIImageView!
  @IBOutlet weak var onSwitch: SevenSwitch!
  
  
  
  weak var delegate: SwitchCellDelegate?
    
  // cell label sets UILabel.text
  var label = "" {
    didSet {
      switchLabel.text = label
    }
  }
  
  // cell UISwitch state
  var switchOn = false {
    didSet {
      if switchOn {
        //onSwitch.isOn = true
        onSwitch.on = true
      } else {
        //onSwitch.isOn = false
        onSwitch.on = false
      }
    }
  }
  
  // hide switch if cell type is checkmark
  var type = cellType.onswitch {
    didSet{
      switch type {
      case .checkmark :
        onSwitch.isHidden = true
      case .onswitch :
        onSwitch.isHidden = false
      }
    }
  }
  
  // show icon images depending on cell state
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
    
    onSwitch.onTintColor = UIColor.white
    
  }
  
  // action for the UI switch
  func switchValueChanged() {
    //print("switch value changed")
    delegate?.switchCell?(self, didChangeValue: onSwitch.isOn())
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
