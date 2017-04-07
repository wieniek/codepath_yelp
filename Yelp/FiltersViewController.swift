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
  
  var switchStates = [IndexPath:Bool]()
  
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
    cell.onSwitch.isOn = switchStates[indexPath] ?? false
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
    switchStates[indexPath] = value
  }
  
  @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  @IBAction func onSearchButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
    var filters = [String:AnyObject]()
    
    var selectedCategories = [String]()
    
    for (indexPath, isSelected) in switchStates {
      if indexPath.section == 3 && isSelected {
        selectedCategories.append(Constants.Yelp.categories[indexPath.row]["code"]!)
      }
    }
    
    if selectedCategories.count > 0 {
      filters["categories"] = selectedCategories as AnyObject
    }
    
    // First switch labeled "Offering a Deal"
    filters["deals"] = switchStates[IndexPath(row: 0, section: 0)] as AnyObject
    
    print("Swiches = \(switchStates)")
    
    // Switch in section 1 row 0 is 0.3 miles = 483 meters
    // Switch in section 1 row 1 is 1 mile = 1609 meters
    // Switch in section 1 row 2 is 5 miles = 8047 meters
    // Switch in section 1 row 3 is 20 miles = 32187 meters
    var distance: Int?
    if switchStates[IndexPath(row: 0, section: 1)] != nil { distance = 483 } else
      if switchStates[IndexPath(row: 1, section: 1)] != nil { distance = 1609 } else
        if switchStates[IndexPath(row: 2, section: 1)] != nil { distance = 8047 } else
          if switchStates[IndexPath(row: 3, section: 1)] != nil { distance = 32187 }
    
    if distance != nil {
      print("Distance = \(distance!)")
      filters["radius"] = distance as AnyObject
    }
    
    var sortMode: YelpSortMode?
    if switchStates[IndexPath(row: 0, section: 2)] != nil { sortMode = YelpSortMode.bestMatched } else
      if switchStates[IndexPath(row: 1, section: 2)] != nil { sortMode = YelpSortMode.distance } else
        if switchStates[IndexPath(row: 2, section: 2)] != nil { sortMode = YelpSortMode.highestRated }
    
    if sortMode != nil {
      print("Sort Mode = \(sortMode!)")
      filters["sort"] = sortMode as AnyObject
    }
    
    delegate?.filtersViewController?(self, didUpdateFilters: filters)
  }
}
