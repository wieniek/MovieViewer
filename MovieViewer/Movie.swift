//
//  Movies.swift
//  MovieViewer
//
//  Created by Wieniek Sliwinski on 3/31/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import Foundation
import AFNetworking

// Data structure which holds movie details
struct Movie {
  
  static let apiKey = "f369874e61746bfeb1fce02b24b3a5cb"
  static let baseUrl = "https://api.themoviedb.org/3/movie/"
  
  var title: String
  var overview: String
  var posterPath: String?
  
  // Initialize and populate details from JSON
  init(jsonResult: NSDictionary) {
    title = jsonResult["title"] as? String ?? ""
    overview = jsonResult["overview"] as? String ?? ""
    posterPath = jsonResult["poster_path"] as? String
  }
  
  // Fetch movie data from from URL
  // static function needs to be run on type
  // Uses AFNetworking library
  static func fetch(fromEndPoint endPoint: String, successCallback success: @escaping ([Movie]) -> Void, errorCallback error: ((NSError?) -> Void)?) {
    
    let url = baseUrl + endPoint + "?api_key=" + apiKey
    
    let manager = AFHTTPSessionManager()
    
    manager.get(url, parameters: nil, progress: nil,
                success:
      { (operation ,responseObject) -> Void in
        
        if let response = responseObject as? NSDictionary {
          if let results = response["results"] as? [NSDictionary] {
            var movies: [Movie] = []
            for result in results as [NSDictionary] {
              movies.append(Movie(jsonResult: result))
            }
            success(movies)
          }
        }
    },
                failure:
      { (operation, requestError) -> Void in
        if let errorCallback = error {
          errorCallback(requestError as NSError)
        }
    })
  }
}
