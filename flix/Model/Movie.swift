//
//  Movie.swift
//  flix
//
//  Created by Mavey Ma on 3/5/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import Foundation

enum MovieKeys {
  static let title = "title"
  static let releaseDate = "release_date"
  static let overview = "overview"
  static let backdropPath = "backdrop_path"
  static let posterPath = "poster_path"
}

class Movie {
  var title: String
  var releaseDate: String?
  var overview: String?
  var backdropURL: URL?
  var posterURL: URL?
  
  init(dictionary: [String: Any]) {
    title = dictionary[MovieKeys.title] as? String ?? "No title"
    releaseDate = dictionary[MovieKeys.releaseDate] as? String ?? "No release date"
    overview = dictionary[MovieKeys.overview] as? String ?? "No overview"
    
    let posterPath = dictionary[MovieKeys.posterPath] as? String
    if let posterPath = posterPath {
      let baseUrlString = "https://image.tmdb.org/t/p/w500"
      let fullPosterPath = baseUrlString + posterPath
      posterURL = URL(string: fullPosterPath)
    }
    
    let backdropPath = dictionary[MovieKeys.backdropPath] as? String
    if let backdropPath = backdropPath {
      let baseUrlString = "https://image.tmdb.org/t/p/w500"
      let fullBackdropPath = baseUrlString + backdropPath
      backdropURL = URL(string: fullBackdropPath)
    }
  }
  
  // You'll often need to create an array of Movies from an array of dictionaries.
  class func movies(dictionaries: [[String: Any]]) -> [Movie] {
    var movies: [Movie] = []
    for dictionary in dictionaries {
      let movie = Movie(dictionary: dictionary)
      movies.append(movie)
    }
    return movies
  }
  
}
