//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Mavey Ma on 2/3/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var movies: [[String: Any]] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    // myMovieDatabaseAPIKey is hidden in Keys.plist
    var keys: NSDictionary?
    
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    if let dict = keys {
      let myKey = dict["myMovieDatabaseAPIKey"] as! String
      
      // 1. Make network request to movie db api
      let myURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=" + myKey
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
          self.tableView.reloadData()
        }
      }
      task.resume()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    let movie = movies[indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    
    return cell
  }
  
  
  
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
