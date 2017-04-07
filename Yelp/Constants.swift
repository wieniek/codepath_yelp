//
//  Constants.swift
//  Yelp
//
//  Created by Wieniek Sliwinski on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

struct Constants {
  struct Filters {
    static let headerTitles = [nil, "Distance", "Sort By", "Category"]
    static let distanceOptions = ["0.3 miles", "1 mile", "5 miles", "20 miles"]
    static let sortOptions = ["Best match", "Distance", "Highest rated"]
    static let dealLabel = "Offering a Deal"
  }
  
  struct Yelp {
    static let categories = [
      ["name" : "Soup", "code" : "soup"],
      ["name" : "Thai", "code" : "thai"],
      ["name" : "Seafood", "code" : "seafood"],
      ["name" : "Irish", "code" : "irish"]
    ]
  }
}
