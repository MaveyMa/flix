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
    cell.movie = movies[indexPath.item]
    return cell
  }
  
  func fetchMovies() {
    MovieApiManager().superheroMovies { (movies: [Movie]?, error: Error?) in
      if let movies = movies {
        self.movies = movies
        self.collectionView.reloadData()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
