//
//  PlayVideoButtonView.swift
//  Movies
//
//  Created by Igor Medelian on 3/8/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import SwiftUI

struct PlayVideoButton: View {
    var title: String
    var subTitle: String
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: { self.action?() }) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color("playVideo"))
                    .frame(width: 60.0, height: 60.0)
                VStack(alignment: .leading) {
                    Text(title)
                    Text(subTitle)
                }
                Spacer()
            }
        }
        .padding(.leading, 10)
        .accentColor(.primary)
    }
}

struct PlayVideoButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlayVideoButton(title: "Command Spot", subTitle: "Teaser")
    }
}
