//
//  MovieCell.swift
//  MovieListTableViewMVVM
//
//  Created by Vinnie Liu on 15/10/19.
//  Copyright © 2019 Yawei Liu. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieCoverImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    //here we use NSCache to save downloaded image data to memory, coz we don't need to do the image data fetching over and over again when scrolling, this could be data expensive
    var cache = NSCache<AnyObject, AnyObject>()
    
    var movieViewModel: MovieViewModel! {
        didSet {
            movieTitleLabel.text = movieViewModel.title
            
            //first we will check if there is any image data with the Movie title as the key, if yes, we will directly use it instead of downloading again
            if let img = cache.object(forKey: movieViewModel.title as AnyObject) {
                movieCoverImageView.image = img as? UIImage
            }else {
                DispatchQueue.global().async {
                    print("Downloaded a new image with URL: " + self.movieViewModel.coverImageUrlString)
                    //here we will download the image data on the global thread
                    let data = NSData(contentsOf: URL(string: self.movieViewModel.coverImageUrlString)!)
                    DispatchQueue.main.async {
                        //here we will update the cell on the main thread and save the image data into memory with the movie title as the key
                        self.movieCoverImageView.image = UIImage(data: data! as Data)
                        self.cache.setObject(UIImage(data: data! as Data)!, forKey: self.movieViewModel.title as AnyObject)
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
