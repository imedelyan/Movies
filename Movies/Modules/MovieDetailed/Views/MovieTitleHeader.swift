//
//  MovieTitleHeader.swift
//  Movies
//
//  Created by Igor Medelian on 3/9/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import SwiftUI

struct MovieTitleHeader: View {
    var title: String?
    
    var body: some View {
        HStack {
            Text(title ?? "")
                .foregroundColor(.white)
                .font(.system(size: 20.0, weight: .bold))
                .padding(10)
            Spacer()
        }
        .frame(height: 60.0)
        .frame(maxWidth: .infinity)
        .background(Color("detailedHeaderBackground"))
    }
}

struct MovieTitleHeader_Previews: PreviewProvider {
    static var previews: some View {
        MovieTitleHeader(title: "Some Movie")
    }
}
