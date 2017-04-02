//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Wieniek Sliwinski on 3/28/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var errorImage: UIImageView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  // arrays to store movie info
  var movies = [Movie]()
  var moviesFiltered = [Movie]()
  
  // Refresh control for table view
  let refreshControl = UIRefreshControl()
  
  // Part of url which varies depending on required source
  var endPoint = ""
  
  // Action triggered by user clicking segmented control
  @IBAction func changeViewType(_ sender: UISegmentedControl) {
    
    // switch on segment selected
    switch sender.selectedSegmentIndex {
    case 0:
      // collection view selected
      collectionView.isHidden = false
    case 1:
      // table view selected
      collectionView.isHidden = true
    default: break
    }
  }
    
  // Setup error view and hide it before loading the table view
  override func viewWillAppear(_ animated: Bool) {
    errorImage.image = UIImage(named: "error")
    errorView.alpha = 0.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // set MoviesViewController as delegate and data source
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    collectionView.dataSource = self
    collectionView.delegate = self
    
    // Add refresh control to table view
    refreshControl.addTarget(self, action: #selector(loadDataFromNetwork), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    // Position segmented control on top of the navigation bar
    navigationItem.titleView = segmentedControl
    
    // Could not find strightforward way to chage search bar icon color
    // This is a bit convoluted solution found on stackoverflow.com
    // http://stackoverflow.com/questions/35699859
    let textField = searchBar.value(forKey: "searchField") as! UITextField
    let glassIconView = textField.leftView as! UIImageView
    glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    glassIconView.tintColor = UIColor.black
    let clearButton = textField.value(forKey: "clearButton") as! UIButton
    clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
    clearButton.tintColor = UIColor.black
    
    // Load data to movie arrays
    loadDataFromNetwork()
  }
  
  // Display HUD and then asynch data load with callbacks
  func loadDataFromNetwork() {
    // Display HUD right before network request is made
    MBProgressHUD.showAdded(to: self.view, animated: true)
    // Fetch data from network url
    Movie.fetch(fromEndPoint: endPoint, successCallback: loadFetch, errorCallback: showErrorView)
  }
  
  // Sucessful callback, load results to movie arrays
  func loadFetch(results: [Movie]){
    movies = results
    moviesFiltered = results
    // hide error view, just in case it was visible
    errorView.alpha = 0.0
    tableView.reloadData()
    collectionView.reloadData()
    // Hide HUD and refresh control
    MBProgressHUD.hide(for: self.view, animated: true)
    refreshControl.endRefreshing()
  }
  
  // Network error, show hidden error view
  func showErrorView(error: NSError?){
    // show error view
    errorView.alpha = 1.0
    tableView.reloadData()
    collectionView.reloadData()
    // Hide HUD and refresh control
    MBProgressHUD.hide(for: self.view, animated: true)
    refreshControl.endRefreshing()
  }
  
  // implement UITableViewDataSource required methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // return number of rows in table view
    return moviesFiltered.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // set content of individual cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    // get movie corresponding to indexPath from the movies array
    let movie = moviesFiltered[indexPath.row]
    
    // create poster URL and set image view
    if let posterPath = movie.posterPath {
      let baseUrl = "https://image.tmdb.org/t/p/w500"
      let imageUrl = URL(string: baseUrl + posterPath)
      cell.posterView.setImageWith(imageUrl!)
    }
    cell.titleLabel.text = movie.title
    cell.overviewLabel.text = movie.overview
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Get rid of the gray selection effect by deselecting the cell
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // implement UICollectionViewDataSource required methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // return number of items in collection view
    return moviesFiltered.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // add movie poster to cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
    
    // get movie corresponding to indexPath from the movies array
    let movie = moviesFiltered[indexPath.row]
    // get data and set the image
    if let posterPath = movie.posterPath {
      let baseUrl = "https://image.tmdb.org/t/p/w500"
      let imageUrl = URL(string: baseUrl + posterPath)
      cell.moviePoster.setImageWith(imageUrl!)
    }
    return cell
  }
  
  // Populate moviesFiltered dictionary based on searched text
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText != "" {
      moviesFiltered = movies.filter { String(describing: $0.title).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil}
    } else {
      moviesFiltered = movies
    }
    tableView.reloadData()
    collectionView.reloadData()
  }
  
  // Navigation seque transition to DetailViewController
  // sender is cell clicked by user
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    var indexPath: IndexPath?
    
    // Check which view controller initiated the seque
    if segue.identifier == "CollectionViewSegue" {
      // get selected cell index
      let cell = sender as! UICollectionViewCell
      indexPath = collectionView.indexPath(for: cell)
    } else {
      // get selected cell index
      let cell = sender as! UITableViewCell
      indexPath = tableView.indexPath(for: cell)
    }
    
    // get movie details for selected cell
    let movie = moviesFiltered[(indexPath?.row)!]
    // cast destination view controller to set movie property
    let detailViewController = segue.destination as! DetailViewController
    detailViewController.movie = movie
  }
}
