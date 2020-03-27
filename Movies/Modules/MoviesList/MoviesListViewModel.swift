//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Combine
import CoreData
import SwiftUI

final class MoviesListViewModel: ObservableObject {
    // MARK: - Observable vars
    @Published var isLoading = false
    @Published var filteredMovies: [Movie] = []
    @Published var searchString: String = ""
    
    // MARK: - Dependencies
    private let moviesAPIService: MoviesAPIService
    private let moc: NSManagedObjectContext
    
    // MARK: - Vars
    private var movies: [Movie] = [] {
        didSet { filterMovies(searchString: searchString) }
    }
    private var disposables = Set<AnyCancellable>()
    private let scheduler = DispatchQueue(label: "MoviesListViewModel")
    private var nextPageToLoad = 1
    private var totalPages = 1
    private let moviesPerPage = 20
    
    var navigationTitle = "Pop Movies"
    var placeholderText = "Choose movie swiping from the left or using landscape orientation"
    var searchPlaceholderText = "Search movie"
    
    // MARK: - Init
    init(moviesAPIService: MoviesAPIService, moc: NSManagedObjectContext) {
        self.moviesAPIService = moviesAPIService
        self.moc = moc
        calculateLoadedPages()
        loadMovies()
        
        $searchString
            .dropFirst(1)
            .debounce(for: .seconds(0.5), scheduler: scheduler)
            .sink(receiveValue: filterMovies(searchString:))
            .store(in: &disposables)
    }
    
    deinit {
        disposables.forEach { $0.cancel() }
    }
    
    // MARK: - Interface
    func loadMovies() {
        guard shouldLoadMoreMovies() else { return }
        isLoading = true
        
        moviesAPIService
            .loadMovies(page: nextPageToLoad)
            .receive(on: DispatchQueue.main)
            .map { ($0.totalPages, $0.movies) }
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        guard let self = self else { return }
                        self.isLoading = false
                        self.movies = Movie.fetchAll(inContext: self.moc)
                    }
                },
                receiveValue: { [weak self] (totalPages, movies) in
                    guard let self = self else { return }
                    movies.forEach { Movie.save(from: $0, inContext: self.moc)}
                    self.totalPages = totalPages
                    self.nextPageToLoad += 1
                    self.isLoading = false
                    self.movies = Movie.fetchAll(inContext: self.moc)
            })
            .store(in: &disposables)
    }
    
    private func filterMovies(searchString: String) {
        guard !searchString.isEmpty else {
            filteredMovies = movies
            return
        }
        filteredMovies = movies.filter { $0.title?.contains(searchString) ?? false }
    }
    
    private func shouldLoadMoreMovies() -> Bool {
        guard !isLoading else { return false }
        guard nextPageToLoad <= totalPages else { return false }
        return true
    }
    
    private func calculateLoadedPages() {
        let savedMovies = try? moc.fetch(Movie.fetchRequest())
        guard let savedMoviesCount = savedMovies?.count else { return }
        let loadedPages = Int(Double(savedMoviesCount / moviesPerPage).rounded(.down))
        nextPageToLoad = loadedPages + 1
        totalPages = loadedPages + 1
    }
}

// MARK: - Builder
extension MoviesListViewModel {
    func movieDetailedView(forMovie movie: Movie) -> some View {
        let viewModel = MovieDetailedViewModel(movie: movie, moviesAPIService: moviesAPIService, moc: moc)
        return MovieDetailedView(viewModel: viewModel)
    }
    
    func moviePosterCell(forMovie movie: Movie) -> some View {
        let viewModel = MoviePosterCellViewModel(movie: movie)
        return MoviePosterCell(viewModel: viewModel)
    }
}
