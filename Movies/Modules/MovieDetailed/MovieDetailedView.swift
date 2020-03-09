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
    var movie: Movie
    
    var body: some View {
        ScrollView {
            VStack {
                MovieTitleHeader(title: movie.title)
                HStack {
                    MoviePosterView(posterPath: movie.posterPath)
                    Spacer()
                    VStack {
                        Text(movie.releaseDate?.prefix(4) ?? "")
                            .padding(.bottom, 30.0)
                        Text("\(String(movie.voteAverage))/10")
                            .padding(.bottom, 30.0)
                        Button(action: {}) {
                            Text("BUTTON")
                                .padding(.all, 20)
                                .foregroundColor(.primary)
                                .background(Color("buttonBackground"))
                                .font(.system(size: 16.0, weight: .bold))
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(10)
                Text(movie.overview ?? "")
                    .padding(10)
                Divider()
                    .background(Color("playVideo"))
                    .padding(10)
                PlayVideoButton(title: "Official Trailer", subTitle: "Trailer")
                PlayVideoButton(title: "Find Spot", subTitle: "Teaser")
                PlayVideoButton(title: "Command Spot", subTitle: "Teaser")
                Spacer()
            }
            .navigationBarTitle(Text("Movie Details"))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
