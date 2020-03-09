//
//  HostingController.swift
//  Movies
//
//  Created by Igor Medelian on 3/8/20.
//  Copyright © 2020 Medelian. All rights reserved.
//

import UIKit
import SwiftUI

// Custom HostingController to force UIStatusBarStyle of the app
class HostingController<Content>: UIHostingController<Content> where Content: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
