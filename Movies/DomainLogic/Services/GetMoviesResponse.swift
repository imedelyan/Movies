//
//  GetMoviesResponse.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Foundation

struct GetMoviesResponse {
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
}

extension GetMoviesResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}
