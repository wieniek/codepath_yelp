//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {
  
  var businesses: [Business]!
  var businessesFiltered: [Business]!
  
  var searchBar = UISearchBar()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    searchBar.delegate = self
    
    // add searchbar to top navigation bar
    searchBar.placeholder = "search for food..."
    navigationItem.titleView = self.searchBar
    
    Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
      
      self.businesses = businesses
      self.businessesFiltered = businesses
      
      self.tableView.reloadData()
      
      if let businesses = businesses {
        for business in businesses {
          print(business.name!)
          print(business.address!)
        }
      }
      
    }
    )
    
    /* Example of Yelp search with more search options specified
     Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
     self.businesses = businesses
     
     for business in businesses {
     print(business.name!)
     print(business.address!)
     }
     }
     */
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    // populate businessesFiltered array based on NAME search results
    if searchText != "" {
      businessesFiltered = businesses.filter { String(describing: $0.name).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil}
    } else {
      businessesFiltered = businesses
    }
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if businessesFiltered != nil {
      return businessesFiltered.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
    cell.business = businessesFiltered[indexPath.row]
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // Check which view controller initiated the seque
    if segue.identifier == "FiltersSegue" {
      let navigationController = segue.destination as! UINavigationController
      let filtersViewController = navigationController.topViewController as! FiltersViewController
      filtersViewController.delegate = self
    } else if segue.identifier == "DetailsSegue" {
      let detailsViewController = segue.destination as! DetailsViewController
      let cell = sender as! UITableViewCell
      let indexPath = tableView.indexPath(for: cell)
      let business = businessesFiltered[indexPath!.row]
      detailsViewController.business = business
    } else if segue.identifier == "MapSegue" {
      let mapViewController = segue.destination as! MapViewController
      mapViewController.businesses = businesses
    }
  }
  
  func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
    
    let deals = filters["deals"] as? Bool
    
    let radius = filters["radius"] as? Int
    
    let categories = filters["categories"] as? [String]
    
    let sort = filters["sort"] as? YelpSortMode
    
    Business.searchWithTerm(term: "Restaurants", sort: sort, radius: radius, categories: categories, deals: deals,
                            completion: {
                              (businesses: [Business]!, error: Error!) -> Void in
                              self.businesses = businesses
                              self.businessesFiltered = businesses
                              self.tableView.reloadData() })
  }
}
