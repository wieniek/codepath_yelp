//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
  @objc optional func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  weak var delegate: FiltersViewControllerDelegate?
  
  var switchStates = [Int:Bool]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("did select row")
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
    switch indexPath.section {
    case 0:
      cell.switchLabel.text = Constants.Filters.dealLabel
    case 1:
      cell.switchLabel.text = Constants.Filters.distanceOptions[indexPath.row]
    case 2:
      cell.switchLabel.text = Constants.Filters.sortOptions[indexPath.row]
    case 3:
      cell.switchLabel.text = Constants.Yelp.categories[indexPath.row]["name"]
    default:
      break
    }
    cell.delegate = self
    cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0:
      return 1
    case 1:
      return 4
    case 2:
      return 3
    case 3:
      return Constants.Yelp.categories.count
    default:
      return 0
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return Constants.Filters.headerTitles[section]
  }
  
  // impement delegate method
  func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool) {
    let indexPath = tableView.indexPath(for: switchCell)!
    switchStates[indexPath.row] = value
  }
  
  @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  @IBAction func onSearchButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
    var filters = [String:AnyObject]()
    
    var selectedCategories = [String]()
    
    for (row, isSelected) in switchStates {
      if row > 0 && isSelected {
        selectedCategories.append(Constants.Yelp.categories[row]["code"]!)
      }
    }
    
    // First switch is labeled "Offering a Deal"
    filters["deals"] = switchStates[0] as AnyObject
    
    filters["radius_filter"] = 1000 as AnyObject
    
    if selectedCategories.count > 0 {
      filters["categories"] = selectedCategories as AnyObject
    }
    
    delegate?.filtersViewController?(self, didUpdateFilters: filters)
  }
}
