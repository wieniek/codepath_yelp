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
    
    categories = yelpCategories()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
    cell.switchLabel.text = categories[indexPath.row]["name"]
    cell.delegate = self
    cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  // impement delegate method
  func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool) {
    let indexPath = tableView.indexPath(for: switchCell)!
    switchStates[indexPath.row] = value
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
  
  func yelpCategories() -> [[String:String]] {
    return [
      ["name" : "Soup", "code" : "soup"],
      ["name" : "Thai", "code" : "thai"],
      ["name" : "Seafood", "code" : "seafood"],
      ["name" : "Irish", "code" : "irish"]
    ]
  }
  
}
