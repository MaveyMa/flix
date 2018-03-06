//
//  Movie.swift
//  flix
//
//  Created by Mavey Ma on 3/5/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import Foundation

class Movie {
  var title: String
  var overview: String?
  var posterURL: URL?
  
  init(dictionary: [String: Any]) {
    title = dictionary["title"] as? String ?? "No title"
    overview = dictionary["overview"] as? String ?? "No overview"
    posterURL = dictionary[]
    
    let posterPath = dictionary["poster_path"] as? String
    if let posterPath = posterPath {
      let baseUrlString = "https://image.tmdb.org/t/p/w500"
      let fullPosterPath = baseUrlString + posterPath
      posterUrl = URL(string: fullPosterPath)
    }
  }
  
}
