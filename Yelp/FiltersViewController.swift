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
    //print("did select section  = \(indexPath.section)")
    //print("did select row  = \(indexPath.row)")
    //print("did select section is \(sectionCollapseStates[indexPath.section])")
    
    //print("did set to true:")
    //print("section  = \(indexPath.section)")
    //print("row  = \(indexPath.row)")
    
    
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
    
    // clear values to avoid reuse effect
    cell.accessoryType = .none
    cell.switchLabel.text = nil
    cell.onSwitch.isOn = false
    cell.onSwitch.isHidden = false
    
    
    if Constants.filtersSections[indexPath.section].collapsible {
      
      //print("ACC- INDEX PATH = \(indexPath)")
      //print("ACC- STATES = \(switchStates[indexPath])")
      
      
      // if section is collapsible then hide switch and show checkmark if selected
      cell.onSwitch.isHidden = true
      if let switchState = switchStates[indexPath]  {
        if switchState {
          
          
          cell.accessoryType = .checkmark
        }
      }
      
      
      // if section collapse state is true, then show selected row and checkmark
      if sectionCollapseStates[indexPath.section] {
        
        let selectedRows = switchStates.filter { $1 == true }
        let selectedRowInSection = selectedRows.filter { $0.key.section == indexPath.section }[0].key
        //print("selected cell index = \(selectedIndex)")
        //print("selected cell text = \(Constants.filtersSections[indexPath.section].cellLabels[selectedIndex.row])")
        
        cell.switchLabel.text = Constants.filtersSections[indexPath.section].cellLabels[selectedRowInSection.row]
        cell.accessoryType = .checkmark
      } else {
        
        cell.switchLabel.text = Constants.filtersSections[indexPath.section].cellLabels[indexPath.row]
        
      }
      
    } else {
      // section is not collapsible
      cell.switchLabel.text = Constants.filtersSections[indexPath.section].cellLabels[indexPath.row]
      cell.onSwitch.isOn = switchStates[indexPath] ?? false
    }
    
    
    
    
    cell.delegate = self
    
    //    print("INDEX PATH = \(indexPath)")
    //    print("STATES = \(switchStates[indexPath])")
    
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
    
    // only chcnge switch state if section is not collapsed
    if Constants.filtersSections[indexPath.section].collapsible && sectionCollapseStates[indexPath.section] == true  {
      switchStates[indexPath] = value
    }
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
    
    //print("Swiches = \(switchStates)")
    
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
