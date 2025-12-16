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
