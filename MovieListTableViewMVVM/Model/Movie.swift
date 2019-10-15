//
//  Movie.swift
//  MovieListTableViewMVVM
//
//  Created by Vinnie Liu on 15/10/19.
//  Copyright © 2019 Yawei Liu. All rights reserved.
//

import Foundation

//this struct is used to construct a Movie object fetched from the API
struct Movie {
    let title: String
    let imageHref: String
    let rating: Double
    let releaseDate: String
}
