//
//  MovieDetailedView.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import SwiftUI

struct MovieDetailedView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: MovieDetailedViewModel
    
    init(viewModel: MovieDetailedViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                MovieTitleHeader(title: viewModel.title)
                HStack {
                    MoviePosterView(posterPath: viewModel.posterPath) 
                    Spacer()
                    VStack {
                        Text(viewModel.releaseDate)
                            .padding(.bottom, 30.0)
                        Text(viewModel.voteAverage)
                            .padding(.bottom, 30.0)
                        Button(action: { self.viewModel.onFavorite() }) {
                            Image(self.viewModel.favoriteImageName)
                                .foregroundColor(self.viewModel.favoriteColor)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(10)
                Text(viewModel.overview)
                    .padding(10)
                Divider()
                    .background(Color("playVideo"))
                    .padding(10)
                PlayVideoButton(title: "Official Trailer", subTitle: "Trailer")
                PlayVideoButton(title: "Find Spot", subTitle: "Teaser")
                PlayVideoButton(title: "Command Spot", subTitle: "Teaser")
                Spacer()
            }
            .navigationBarTitle(Text(viewModel.navigationTitle))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
        .onAppear { self.viewModel.onAppear() }
    }
}
