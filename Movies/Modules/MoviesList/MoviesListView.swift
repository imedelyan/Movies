//
//  MoviesListView.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import Foundation
import SwiftUI

struct MoviesListView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject private var viewModel: MoviesListViewModel
    
    init(viewModel: MoviesListViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    self.searchField
                    self.moviesView(parentGeometry: geometry)
                        .frame(minHeight: geometry.frame(in: .global).height)
                }
                .background(Color("defaultBackground"))
                .edgesIgnoringSafeArea(.bottom)
                .edgesIgnoringSafeArea(.horizontal)
            }
            .navigationBarTitle(Text(viewModel.navigationTitle))
            // Detailed view placeholder
            Text(viewModel.placeholderText)
        }
        .accentColor( .white)
        .phoneOnlyStackNavigationView()
    }
}

extension MoviesListView {
    private var searchField: some View {
        HStack(alignment: .center) {
            TextField(viewModel.searchPlaceholderText, text: $viewModel.searchString)
        }
        .frame(height: 60.0)
        .background(Color(.white))
    }
    
    // Calculate rows and columns, make Movies stack view
    private func moviesView(parentGeometry: GeometryProxy) -> some View {
        let screenWidth = parentGeometry.frame(in: .global).width
        let colsCount = Int((screenWidth / CGFloat(Constants.PosterImageWidth.small)).rounded())
        let rowRemainder = Double(viewModel.filteredMovies.count).remainder(dividingBy: Double(colsCount))
        let rowsCount = viewModel.filteredMovies.count / colsCount + (rowRemainder == 0 ? 0 : 1)
        let cellWidth = screenWidth/CGFloat(colsCount)

        return VStack(spacing: 0) {
            ForEach(0..<rowsCount, id: \.self) { rowIndex in
                Group {
                    HStack(spacing: 0) {
                        ForEach(0..<colsCount, id: \.self) { colIndex in
                            self.movieCell(colsCount: colsCount, colIndex: colIndex, rowIndex: rowIndex, width: cellWidth)
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
    
    // MoviePosterCell with NavigationLink to MovieDetailed view
    private func movieCell(colsCount: Int, colIndex: Int, rowIndex: Int, width: CGFloat) -> some View {
        let cellIndex = (rowIndex * colsCount) + colIndex
        return Group {
            if cellIndex < self.viewModel.filteredMovies.count {
                NavigationLink(destination: viewModel.movieDetailedView(forMovie: self.viewModel.filteredMovies[cellIndex])) {
                    viewModel.moviePosterCell(forMovie: self.viewModel.filteredMovies[cellIndex])
                        .frame(maxWidth: width)
                }
            } else {
                Spacer()
            }
        }
    }
}
