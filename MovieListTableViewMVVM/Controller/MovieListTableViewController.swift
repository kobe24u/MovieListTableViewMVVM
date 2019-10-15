//
//  MovieListTableViewController.swift
//  MovieListTableViewMVVM
//
//  Created by Vinnie Liu on 15/10/19.
//  Copyright © 2019 Yawei Liu. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {

    //here we use MovieViewModel as the bridge for communication, Controller won't talk to raw custom object any more
    var movieViewModels = [MovieViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieData()
    }
    
    //here we will do the API call to fetch the data using complition handler
    //we won't go further if the data fetch process has an error
    fileprivate func fetchMovieData() {
        FetchService.shared.fetchMovies { (movies, err) in
            if let err = err {
                print("Failed to fetch movie data:", err)
                return
            }
            print("there are \(String(describing: movies?.count)) movie objects fetched")
            //we will transform the array of Movie objects to an array of MovieViewModel objects
            self.movieViewModels = movies?.map({return MovieViewModel(movie: $0)}) ?? []
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieViewModel = movieViewModels[indexPath.row]
        //In MVVM, the controller will only talks to MovieViewModel, it is not aware of the raw Movie class any more
        cell.movieViewModel = movieViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 500
    }
}
