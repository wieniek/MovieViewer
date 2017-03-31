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
  var movie: NSDictionary?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set scroll view content size
    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
    
    
    // after view is loaded, get movie details and set labels
    let title = movie?["title"] as? String
    titleLabel.text = title
    let overview = movie?["overview"] as? String
    overviewLabel.text = overview
    // sizeToFit sets label text top vertical aligment
    overviewLabel.sizeToFit()
    
    // create poster URL and set image view
    if let posterPath = movie?["poster_path"] as? String {
      let baseUrl = "https://image.tmdb.org/t/p/w500"
      let imageUrl = URL(string: baseUrl + posterPath)
      posterImageView.setImageWith(imageUrl!)
    }
    
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
