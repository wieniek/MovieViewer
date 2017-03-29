//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Wieniek Sliwinski on 3/28/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  
  @IBOutlet weak var tableView: UITableView!
  
  // array of dictionaries which represents each movie
  // retrieved with URLSession network request
  var movies: [NSDictionary]?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // set MoviesViewController as TableView DataSource and Delegate
    tableView.dataSource = self
    tableView.delegate = self
    
    // network request using URLSession
    let apiKey = "f369874e61746bfeb1fce02b24b3a5cb"
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      if let error = error {
        //errorCallBack?(error)
        print("ERROR = \(error)")
      } else if let data = data,
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
        print("JSON OKAY")
        //print(dataDictionary)
        // load results to movies variable
        self.movies = dataDictionary["results"] as? [NSDictionary]
        self.tableView.reloadData()
        //successCallBack(dataDictionary)
      }
    }
    task.resume()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // implement UITableViewDataSource required methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // set number of rows in table view
    if let movies = movies {
      return movies.count
    } else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // set content of individual cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    // get movie corresponding to indexPath from the movies array
    let movie = movies![indexPath.row]
    // get data and set the labeles
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    let posterPath = movie["poster_path"] as! String
    
    // create poster URL and set image view
    let baseUrl = "https://image.tmdb.org/t/p/w500"
    if let imageUrl = URL(string: baseUrl + posterPath) {
      cell.posterView.setImageWith(imageUrl)
    }
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview

    
    
    
    return cell
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
