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
        customizeRefreshController()
    }
    
    func customizeRefreshController(){
        // Add Refresh Control to Table View, when the user pull and release it will refresh the tableview
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:  #selector(fetchMovieData), for: .valueChanged)
            
            // Green color
            let greenColor = UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 1.0)
            var attributes = [NSAttributedString.Key: AnyObject]()
            attributes[.foregroundColor] = greenColor
            //we will show the user a prompt message, when he pulls and release, the table view will refresh itself
            let attributedString = NSAttributedString(string: "Pull and release to refresh...", attributes: attributes)
            refreshControl.tintColor = greenColor
            refreshControl.attributedTitle = attributedString
            self.refreshControl = refreshControl
        }
    }
    
    //here we will do the API call to fetch the data using complition handler
    //we won't go further if the data fetch process has an error
    @objc fileprivate func fetchMovieData() {
        FetchService.shared.fetchMovies { (movies, err) in
            if let err = err {
                print("Failed to fetch movie data:", err)
                return
            }
            self.movieViewModels.removeAll()
            print("there are \(String(describing: movies?.count)) movie objects fetched")
            //we will transform the array of Movie objects to an array of MovieViewModel objects
            self.movieViewModels = movies?.map({return MovieViewModel(movie: $0)}) ?? []
            self.refreshControl?.endRefreshing()
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
