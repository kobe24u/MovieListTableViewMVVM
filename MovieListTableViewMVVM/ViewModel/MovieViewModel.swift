//
//  MovieViewModel.swift
//  MovieListTableViewMVVM
//
//  Created by Vinnie Liu on 15/10/19.
//  Copyright © 2019 Yawei Liu. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {
    
    let title: String
    let coverImageUrlString: String
    
    // Dependency Injection (DI), so it has access to the raw Movie object now
    init(movie: Movie) {
        self.title = movie.title
        self.coverImageUrlString = movie.imageHref
    }
    
}
