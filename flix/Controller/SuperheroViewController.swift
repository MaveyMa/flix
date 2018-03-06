//
//  SuperheroViewController.swift
//  flix
//
//  Created by Mavey Ma on 2/10/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var movies: [Movie] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = layout.minimumInteritemSpacing
    let cellPerLine: CGFloat = 2
    let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellPerLine - 1)
    
    let width = collectionView.frame.size.width / cellPerLine - interItemSpacingTotal / cellPerLine
    layout.itemSize = CGSize(width: width, height: width * 3 / 2)
    
    
    fetchMovies()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
    let movie = movies[indexPath.item]
    if movie.posterURL != nil {
      cell.posterImageView.af_setImage(withURL: movie.posterURL!)
    }
    return cell
  }
  
  func fetchMovies() {
    // myMovieDatabaseAPIKey is hidden in Keys.plist
    var keys: NSDictionary?
    
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    if let dict = keys {
      let myKey = dict["myMovieDatabaseAPIKey"] as! String
      
      // 1. Make network request to movie db api
      let myURL = "https://api.themoviedb.org/3/movie/284054/similar?api_key=" + myKey + "&language=en-US&page=2"
      let url = URL(string: myURL)!
      let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData , timeoutInterval: 10)
      let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
      
      // 2. Get JSON back
      let task = session.dataTask(with: request) { (data, response, error) in
        // This will run when the network request returns
        if let error = error {
          print(error.localizedDescription)
        } else if let data = data {
          // 3. Turn JSON into a dictionary
          let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
          // 4. Parse dictionary to access individual keys
          let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
          self.movies = Movie.movies(dictionaries: movieDictionaries)
          self.collectionView.reloadData()
        }
      }
      task.resume()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
