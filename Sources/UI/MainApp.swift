//
//  MainApp.swift
//
//
//  Created by Daniel Bond on 09.12.2025.
//

import Foundation
import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabBarControllerWrapper()
        }
    }
}

#Preview{
    MainTabBarControllerWrapper()
}
