//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Mavey Ma on 2/3/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import AlamofireImage
import KRProgressHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var movies: [[String: Any]] = []
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    KRProgressHUD.show()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    tableView.dataSource = self
    fetchMovies()
    
    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
      KRProgressHUD.dismiss()
    }
  }
  
  @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
    fetchMovies()
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
          self.refreshControl.endRefreshing()
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
    
    let posterPathString = movie["poster_path"] as! String
    let baseURLString = "https://image.tmdb.org/t/p/w500"
    let posterURL = URL(string: baseURLString + posterPathString)!
    cell.posterImageView.af_setImage(withURL: posterURL)
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    if let indexPath = tableView.indexPath(for: cell) {
      let movie = movies[indexPath.row]
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.movie = movie
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
}