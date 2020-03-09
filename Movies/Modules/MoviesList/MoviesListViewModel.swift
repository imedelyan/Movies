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
    
    // MARK: - Dependencies
    private let moviesAPIService: MoviesAPIService
    private let moc: NSManagedObjectContext
    
    // MARK: - Vars
    private var disposables = Set<AnyCancellable>()
    private var nextPageToLoad = 1
    private var totalPages = 1
    private let moviesPerPage = 20
    
    // MARK: - Init
    init(moviesAPIService: MoviesAPIService, moc: NSManagedObjectContext) {
        self.moviesAPIService = moviesAPIService
        self.moc = moc
        calculateLoadedPages()
        loadMovies()
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
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.isLoading = false
                }
            }) { [weak self] (totalPages, movies) in
                guard let self = self else { return }
                movies.forEach { Movie.save(from: $0, inContext: self.moc)}
                self.totalPages = totalPages
                self.nextPageToLoad += 1
                self.isLoading = false
            }
            .store(in: &disposables)
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
