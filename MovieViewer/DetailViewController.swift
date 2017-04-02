//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Wieniek Sliwinski on 3/31/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  // Outlets to DetailViewController UI items
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoView: UIView!
  
  // Dictionary to store movie details populated by seque
  var movie: Movie?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set scroll view content size
    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
    
    // since global scroll view color was set to skyBlue in AppDelegate
    // must undo this change here for detail scroll view
    scrollView.backgroundColor = UIColor.clear
    
    // after view is loaded, get movie details and set labels
    titleLabel.text = movie?.title ?? ""
    overviewLabel.text = movie?.overview ?? ""
    // sizeToFit sets label text top vertical aligment
    overviewLabel.sizeToFit()
    
    // create poster URL and set image view
    if let posterPath = movie?.posterPath {
      let baseUrl = "https://image.tmdb.org/t/p/w500"
      let imageUrl = URL(string: baseUrl + posterPath)
      posterImageView.setImageWith(imageUrl!)
    }
  }
}
