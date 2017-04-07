//
//  SwitchCell.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
  @objc optional func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
  
  @IBOutlet weak var switchLabel: UILabel!
  @IBOutlet weak var onSwitch: UISwitch!
  
  weak var delegate: SwitchCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // hook to UI switch programatically, add target
    onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
    
  }
  
  // action for the UI switch
  func switchValueChanged() {
    print("switch value changed")
      delegate?.switchCell?(self, didChangeValue: onSwitch.isOn)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
