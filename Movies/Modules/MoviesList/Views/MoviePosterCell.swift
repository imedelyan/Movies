//
//  MovieCellView.swift
//  Movies
//
//  Created by Igor Medelian on 3/7/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import struct Kingfisher.KFImage
import SwiftUI

struct MoviePosterCell: View {
    var posterPath: String?
    var title: String?
    @State private var isThereNoPoster = false
    
    var body: some View {
        Group {
            if isThereNoPoster {
                Text(title ?? "Movie")
            } else {
                KFImage(URL(string: "\(Constants.baseImageURLString)w\(Constants.PosterImageWidth.small)\(posterPath ?? "")"))
                    .onFailure { _ in self.isThereNoPoster = true }
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct MovieCellView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterCell(posterPath: "/kqjL17yufvn9OVLyXYpvtyrFfak.jpg",
                        title: "Scary Movie")
            .frame(width: 185.0, height: 250)
    }
}
