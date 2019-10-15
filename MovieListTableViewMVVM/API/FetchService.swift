//
//  FetchService.swift
//  MovieListTableViewMVVM
//
//  Created by Vinnie Liu on 15/10/19.
//  Copyright © 2019 Yawei Liu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FetchService: NSObject {
    static let shared = FetchService()
    
    func fetchMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let urlString = "https://www.dropbox.com/s/q1ins5dsldsojzt/movies.json?dl=1"
        var movies = [Movie]()
        //here we take advantage of Alamofire to make an API call to fetch the JSON reponse
        AF.request(urlString).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                //here we use SwiftyJSON to quickly and safely abstract all attributes of a single Movie record and construct a new Movie object and append to the custom object array for future usage
                let json = JSON(value)
                json["movies"].array?.forEach({ (movie) in
                    //here we should be careful, if the movie's cover image data or rating data is null, we should show something instead of leave it empty for better user experience
                    let newMovieObj = Movie(title: movie["title"].stringValue, imageHref: movie["imageHref"].string ?? "https://1080motion.com/wp-content/uploads/2018/06/NoImageFound.jpg.png", rating: movie["rating"].double ?? 0.0, releaseDate: movie["title"].stringValue)
                    movies.append(newMovieObj)
                })
                //when the for loop is done, we will finish the data fetching process and jump out to the next step
                DispatchQueue.main.async {
                    completion(movies, nil)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}


