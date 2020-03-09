//
//  MoviesService.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Foundation
import Combine

final class MoviesAPIService {
    private lazy var decoder = JSONDecoder()
    
    // Load movies from themoviedb API based on their popularity by pages
    func loadMovies(page: Int) -> AnyPublisher<GetMoviesResponse, Error> {
        let url = URL(string: Constants.baseURLString)!
            .appendingPathComponent("discover/movie")
            .appending("api_key", value: Constants.apiKey)
            .appending("language", value: Locale.preferredLanguages[0])
            .appending("sort_by", value: "popularity.desc")
            .appending("page", value: "\(page)")
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: GetMoviesResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
