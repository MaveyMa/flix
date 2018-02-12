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
  
  var movies: [[String: Any]] = []
  
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
    if let posterPathString = movie["poster_path"] as? String {
      let baseURLString = "https://image.tmdb.org/t/p/w500"
      let posterURL = URL(string: baseURLString + posterPathString)!
      cell.posterImageView.af_setImage(withURL: posterURL)
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
      let myURL = "https://api.themoviedb.org/3/movie/284053/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
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
          let movies = dataDictionary["results"] as! [[String: Any]]
          self.movies = movies
          self.collectionView.reloadData()
          //self.refreshControl.endRefreshing()
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
