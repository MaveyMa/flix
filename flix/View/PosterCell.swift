//
//  PosterCell.swift
//  flix
//
//  Created by Mavey Ma on 2/10/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
  @IBOutlet weak var posterImageView: UIImageView!
  var movie: Movie! {
    didSet {
      posterImageView.af_setImage(withURL: movie.posterURL!)
    }
  }
}
