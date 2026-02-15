import SwiftUI

@main
struct MrBestKeepTheStyleApp: App {
    @StateObject private var viewModel = ViewModelMB()
    
    var body: some Scene {
        WindowGroup {
            MainViewMB()
                .environmentObject(viewModel)
        }
    }
}
