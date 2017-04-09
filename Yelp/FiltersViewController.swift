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
  
  var sectionCollapseStates = [Bool]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    // Initialize section collapsible states
    var sectionNumber = 0
    for section in Constants.filtersSections {
      sectionCollapseStates.append(section.collapsible)
      // if section is collapsible then set first row as selected
      if section.collapsible {
        switchStates[IndexPath(row:0, section: sectionNumber)] = true
      }
      sectionNumber += 1
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if Constants.filtersSections[indexPath.section].collapsible {
      
      // modify switch state only if section is not collapsed
      if !sectionCollapseStates[indexPath.section] {
        
        var rowNumber = 0
        // set all section switches to off
        for _ in Constants.filtersSections[indexPath.section].cellLabels {
          switchStates[IndexPath(row: rowNumber, section: indexPath.section)] = false
          rowNumber += 1
        }
        switchStates[indexPath] = true
      }
      sectionCollapseStates[indexPath.section] = !sectionCollapseStates[indexPath.section]
      tableView.reloadData()
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
    
    // clear values to avoid cell reuse effect
    cell.iconType = nil
    cell.label = ""
    cell.type = .onswitch
    cell.switchOn = false
    
    if Constants.filtersSections[indexPath.section].collapsible {
      
      // if section is collapsible then set cell type and show appropriate icon
      cell.type = .checkmark
      cell.iconType = .uncheck
      if let switchState = switchStates[indexPath]  {
        if switchState {
          cell.iconType = .check
        }
      }
      // if section collapse state is true, then show selected row and dropdown
      if sectionCollapseStates[indexPath.section] {
        
        let selectedRows = switchStates.filter { $1 == true }
        let selectedRowInSection = selectedRows.filter { $0.key.section == indexPath.section }[0].key
        cell.label = Constants.filtersSections[indexPath.section].cellLabels[selectedRowInSection.row]
        cell.iconType = .dropdown
      } else {
        cell.label = Constants.filtersSections[indexPath.section].cellLabels[indexPath.row]
      }
    } else {
      // section is not collapsible
      cell.label = Constants.filtersSections[indexPath.section].cellLabels[indexPath.row]
      cell.switchOn = switchStates[indexPath] ?? false
    }
    cell.delegate = self
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // if section collapse state is true, then set number of rows to 1
    if sectionCollapseStates[section] {
      return 1
    } else {
      return Constants.filtersSections[section].cellLabels.count
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Constants.filtersSections.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Constants.filtersSections[section].title
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
    
    // Distance is displayed in section 1, find selected row
    let selectedRows = switchStates.filter { $1 == true }
    let selectedRowInSection1 = selectedRows.filter { $0.key.section == 1 }[0].key.row
    
    var distance = 0
    switch selectedRowInSection1 {
    case 0: distance = 0          // Distance = Auto
    case 1: distance = 483        // Distance = 0.3 miles = 483 meters
    case 2: distance = 1609       // Distance = 1 mile = 1609 meters
    case 3: distance = 8047       // Distance = 5 miles = 8047 meters
    case 4: distance = 32187      // Distance = 20 miles = 32187 meters
    default: break
    }
    
    // Add distance radius if not Auto
    if distance != 0 {
      filters["radius"] = distance as AnyObject
    }
    
    // Sort mode is displayed in section 2, find selected row
    let selectedRowInSection2 = selectedRows.filter { $0.key.section == 1 }[0].key.row
    
    var sortMode: YelpSortMode?
    switch selectedRowInSection2 {
    case 0: sortMode = YelpSortMode.bestMatched
    case 1: sortMode = YelpSortMode.distance
    case 2: sortMode = YelpSortMode.highestRated
    default: break
    }
    
    filters["sort"] = sortMode as AnyObject
    
    delegate?.filtersViewController?(self, didUpdateFilters: filters)
  }
}
