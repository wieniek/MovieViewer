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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var errorImage: UIImageView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // array of dictionaries which represents each movie
  // retrieved with URLSession network request
  var movies: [NSDictionary]?
  var moviesFiltered: [NSDictionary]?
  var endPoint: String = "now_playing"
  
  // network request using URLSession
  func loadFromUrl() {
    let apiKey = "f369874e61746bfeb1fce02b24b3a5cb"
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    // Display HUD right before network request is made
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      // Hide HUD once the network request comes back
      MBProgressHUD.hide(for: self.view, animated: true)
      // Check for error
      if let error = error {
        // show error view
        self.errorView.alpha = 1.0
        self.tableView.reloadData()
        print("ERROR = \(error)")
      } else if let data = data,
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
        // load results to movies variable
        self.movies = dataDictionary["results"] as? [NSDictionary]
        self.moviesFiltered = self.movies
        // hide error view, just in case it was visible
        // and reload table view
        self.errorView.alpha = 0.0
        self.tableView.reloadData()
      }
    }
    task.resume()
  }
  
  // network request using URLSession
  func loadFromUrl(_ refreshControl: UIRefreshControl) {
    let apiKey = "f369874e61746bfeb1fce02b24b3a5cb"
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      if let error = error {
        // show error view
        self.errorView.alpha = 1.0
        refreshControl.endRefreshing()
        self.tableView.reloadData()
        NSLog("ERROR = \(error)")
      } else if let data = data,
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
        // load results to movies variable
        self.movies = dataDictionary["results"] as? [NSDictionary]
        self.moviesFiltered = self.movies
        // hide error view, just in case it was visible
        // and reload table view
        self.errorView.alpha = 0.0
        refreshControl.endRefreshing()
        self.tableView.reloadData()
      }
    }
    task.resume()
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
    
    // Add refresh control to table view
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(loadFromUrl(_:)), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    // Load data using network request
    loadFromUrl()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // implement UITableViewDataSource required methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // set number of rows in table view
    if let movies = moviesFiltered {
      return movies.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // set content of individual cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    // get movie corresponding to indexPath from the movies array
    let movie = moviesFiltered![indexPath.row]
    // get data and set the labeles
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    
    // create poster URL and set image view
    if let posterPath = movie["poster_path"] as? String {
      let baseUrl = "https://image.tmdb.org/t/p/w500"
      let imageUrl = URL(string: baseUrl + posterPath)
      cell.posterView.setImageWith(imageUrl!)
    }
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Get rid of the gray selection effect by deselecting the cell
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // Populate moviesFiltered dictionary based on searched text
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(" text did change = \(searchText)")
    if searchText != "" {
      moviesFiltered = movies?.filter { String(describing: $0["title"]).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil}
    } else {
      moviesFiltered = movies
    }
    tableView.reloadData()
  }
  
  // Navigation seque transition to DetailViewController
  // sender is MovieCell clicked by user
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // get selected cell index
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)
    
    // get movie details for selected cell
    let movie = moviesFiltered?[(indexPath?.row)!]
    
    // cast destination view controller to set movie property
    let detailViewController = segue.destination as! DetailViewController
    detailViewController.movie = movie
    
  }
}
