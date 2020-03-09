//
//  View+Extension.swift
//  Movies
//
//  Created by Igor Medelian on 3/8/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import SwiftUI

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
