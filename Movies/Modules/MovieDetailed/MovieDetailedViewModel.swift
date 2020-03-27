//
//  MovieDetailedViewModel.swift
//  Movies
//
//  Created by Igor Medelian on 3/26/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Combine
import CoreData
import SwiftUI

final class MovieDetailedViewModel: ObservableObject {
    // MARK: - Observable vars
    @Published var favoriteColor = Color(.gray)
    
    // MARK: - Dependencies
    private let movie: Movie
    private let moviesAPIService: MoviesAPIService
    private let moc: NSManagedObjectContext
    
    // MARK: - Vars
    private var subscriber: AnyCancellable?
    
    var posterPath: String? {
        movie.posterPath
    }
    
    var title: String {
        movie.title ?? "Movie"
    }
    
    var releaseDate: Substring {
        movie.releaseDate?.prefix(4) ?? ""
    }
    
    var voteAverage: String {
        "\(String(movie.voteAverage))/10"
    }
    
    var overview: String {
        movie.overview ?? ""
    }
    
    var navigationTitle = "Movie Details"
    var favoriteImageName = "star-filled"
    
    private var isFavorite = false {
        didSet {
            favoriteColor = isFavorite ? Color(.yellow) : Color(.gray)
            movie.isFavorite = isFavorite
            try? moc.save()
        }
    }
    
    // MARK: - Init
    init(movie: Movie, moviesAPIService: MoviesAPIService, moc: NSManagedObjectContext) {
        self.movie = movie
        self.moviesAPIService = moviesAPIService
        self.moc = moc
    }
    
    deinit {
        subscriber?.cancel()
    }
    
    func onAppear() {
        isFavorite = movie.isFavorite
    }
    
    func onFavorite() {
        subscriber = moviesAPIService.setFavorite(movie: movie)
            .assign(to: \.isFavorite, on: self)
    }
}
