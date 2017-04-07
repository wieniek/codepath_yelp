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
  
  var categories: [[String:String]]!
  var switchStates = [Int:Bool]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    categories = Constants.Yelp.categories
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
      cell.switchLabel.text = Constants.Filters.dealLabel
      cell.delegate = self
      cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
      cell.switchLabel.text = Constants.Filters.distanceOptions[indexPath.row]
      cell.delegate = self
      cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
      cell.switchLabel.text = Constants.Filters.sortOptions[indexPath.row]
      cell.delegate = self
      cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
      cell.switchLabel.text = categories[indexPath.row]["name"]
      cell.delegate = self
      cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
      return cell
    default:
      return UITableViewCell()
    }
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
      return categories.count
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
      if isSelected {
        selectedCategories.append(categories[row]["code"]!)
      }
    }
    
    if selectedCategories.count > 0 {
      filters["categories"] = selectedCategories as AnyObject
    }
    
    delegate?.filtersViewController?(self, didUpdateFilters: filters)
  }
}
