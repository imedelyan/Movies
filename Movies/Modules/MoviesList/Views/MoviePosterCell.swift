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
    @State private var isThereNoPoster = false
    private let viewModel: MoviePosterCellViewModel
    
    init(viewModel: MoviePosterCellViewModel) {
      self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if isThereNoPoster {
                Text(viewModel.title)
            } else {
                KFImage(viewModel.posterURL)
                    .onFailure { _ in self.isThereNoPoster = true }
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}
