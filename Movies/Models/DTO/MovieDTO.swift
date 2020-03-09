//
//  Movie.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Foundation

struct MovieDTO {
    let id: Int32
    let title: String
    let overview: String
    let releaseDate: String
    let popularity: Double
    let voteAverage: Double
    let posterPath: String?
}

extension MovieDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, popularity, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}
