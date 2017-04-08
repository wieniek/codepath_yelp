//
//  Constants.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

struct FiltersSection {
  let title: String?
  let cellLabels: [String]
  let collapsible: Bool
}

struct Constants {
  
  static let filtersSections = [
    FiltersSection( title: nil, cellLabels: ["Offering a Deal"], collapsible: false),
    FiltersSection( title: "Distance", cellLabels: ["Auto","0.3 miles", "1 mile", "5 miles", "20 miles"], collapsible: true),
    FiltersSection( title: "Sort By", cellLabels: ["Best match", "Distance", "Highest rated"], collapsible: false),
    FiltersSection( title: "Category", cellLabels: Yelp.categories.map { $0["name"]! }, collapsible: false),
  ]
  
  struct Filters {
    static let headerTitles = [nil, "Distance", "Sort By", "Category"]

    static let cellLabels = [
      ["Offering a Deal"],
      ["Auto","0.3 miles", "1 mile", "5 miles", "20 miles"],
      ["Best match", "Distance", "Highest rated"],
      Yelp.categories.map { $0["name"]! }
    ]
  }
  
  struct Yelp {
    static let categories = [
      ["name" : "American","code": "tradamerican"],
      ["name" : "Burgers","code": "burgers"],
      ["name" : "Chinese","code": "chinese"],
      ["name" : "Greek","code": "greek"],
      ["name" : "Mexican","code": "mexican"],
      ["name" : "Irish", "code" : "irish"],
      ["name" : "Pizza", "code" : "pizza"],
      ["name" : "Salad", "code" : "salad"],
      ["name" : "Seafood", "code" : "seafood"],
      ["name" : "Soup", "code" : "soup"],
      ["name" : "Thai", "code" : "thai"]
    ]
  }
}
