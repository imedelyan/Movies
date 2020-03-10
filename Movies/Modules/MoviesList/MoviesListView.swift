//
//  MoviesListView.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import SwiftUI

struct MoviesListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: Movie.allMoviesRequest()) var movies: FetchedResults<Movie>
    @ObservedObject private var viewModel: MoviesListViewModel
    
    init(viewModel: MoviesListViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    self.makeMoviesView(parentGeometry: geometry)
                        .frame(minHeight: geometry.frame(in: .global).height)
                }
                .background(Color("defaultBackground"))
                .edgesIgnoringSafeArea(.bottom)
                .edgesIgnoringSafeArea(.horizontal)
            }
            .navigationBarTitle(Text("Pop Movies"))
            // Detailed view placeholder
            Text("Choose movie swiping from the left or using landscape orientation")
        }
        .accentColor( .white)
        .phoneOnlyStackNavigationView()
    }
    
    // Calculate rows and columns, make Movies stack view
    private func makeMoviesView(parentGeometry: GeometryProxy) -> some View {
        let screenWidth = parentGeometry.frame(in: .global).width
        let colsCount = Int((screenWidth / CGFloat(Constants.PosterImageWidth.small)).rounded())
        let rowRemainder = Double(movies.count).remainder(dividingBy: Double(colsCount))
        let rowsCount = movies.count / colsCount + (rowRemainder == 0 ? 0 : 1)
        let cellWidth = screenWidth/CGFloat(colsCount)

        return VStack(spacing: 0) {
            ForEach(0..<rowsCount, id: \.self) { rowIndex in
                Group {
                    HStack(spacing: 0) {
                        ForEach(0..<colsCount, id: \.self) { colIndex in
                            self.makeMovieCell(colsCount: colsCount, colIndex: colIndex, rowIndex: rowIndex, width: cellWidth)
                        }
                    }
                    if rowIndex == rowsCount - 1 {
                        // Load more Movies and add spinner while loading
                        GeometryReader { geometry -> HStack<TupleView<(Spacer, ActivityIndicator, Spacer)>> in
                            if geometry.frame(in: .global).maxY - parentGeometry.size.height < 50 {
                                self.viewModel.loadMovies()
                            }
                            return HStack {
                                Spacer()
                                ActivityIndicator()
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: self.viewModel.isLoading ? 40 : 0)
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    // Make MoviePosterCell with NavigationLink to MovieDetailed view
    private func makeMovieCell(colsCount: Int, colIndex: Int, rowIndex: Int, width: CGFloat) -> some View {
        let cellIndex = (rowIndex * colsCount) + colIndex
        return Group {
            if cellIndex < self.movies.count {
                NavigationLink(destination: MovieDetailedView(movie: self.movies[cellIndex])) {
                    MoviePosterCell(posterPath: self.movies[cellIndex].posterPath,
                                    title: self.movies[cellIndex].title)
                        .frame(maxWidth: width)
                }
            } else {
                Spacer()
            }
        }
    }
}
