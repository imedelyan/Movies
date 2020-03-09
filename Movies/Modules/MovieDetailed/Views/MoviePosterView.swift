//
//  MoviePosterView.swift
//  Movies
//
//  Created by Igor Medelian on 3/8/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import struct Kingfisher.KFImage
import SwiftUI

struct MoviePosterView: View {
    var posterPath: String?
    @State var isShowingPoster = false
    @State var isThereNoPoster = false
    
    var body: some View {
        Group {
            if isThereNoPoster {
                Text("No poster")
                    .foregroundColor(.primary)
            } else {
                Button(action: {
                    self.isShowingPoster.toggle()
                }) {
                    KFImage(URL(string: "\(Constants.baseImageURLString)w\(Constants.PosterImageWidth.small)\(posterPath ?? "")"))
                        .onFailure { _ in self.isThereNoPoster = true }
                        .renderingMode(.original)
                }.sheet(isPresented: $isShowingPoster) {
                    KFImage(URL(string: "\(Constants.baseImageURLString)w\(Constants.PosterImageWidth.medium)\(self.posterPath ?? "")"))
                        .placeholder { Text("Loading") }
                        .renderingMode(.original)
                }
            }
        }
    }
}

struct MoviePosterView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterView(posterPath: "/uPGq1mkEXznUpapDmOSxbsybjfp.jpg")
    }
}
