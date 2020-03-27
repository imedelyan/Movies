//
//  MoviePosterCellViewModel.swift
//  Movies
//
//  Created by Igor Medelian on 3/26/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Foundation

struct MoviePosterCellViewModel {
    private let movie: Movie
    
    var posterURL: URL? {
        URL(string: "\(Constants.baseImageURLString)w\(Constants.PosterImageWidth.small)\(movie.posterPath ?? "")")
    }
    
    var title: String {
        movie.title ?? "Movie"
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
