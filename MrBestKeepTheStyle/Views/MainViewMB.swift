import SwiftUI
import AppTrackingTransparency

struct MainViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @StateObject private var storeManager = StoreManagerMB()
    @State private var isSplashActive = true
    @State private var currentTab: TabMB = .home
    
    init() {
        // Force transparent navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Hide native Tab Bar
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            // Force Dark Background Global
            GlowBackgroundMB()
                .ignoresSafeArea()
                .zIndex(0)
            
            if isSplashActive {
                SplashViewMB()
                    .transition(.opacity)
                    .zIndex(2)
                    .onAppear {
                        // Request tracking on splash screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            requestTracking()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Extended slightly to allow interaction if needed, or just flow
                            withAnimation {
                                isSplashActive = false
                            }
                        }
                    }
            } else {
                if viewModel.showOnboarding {
                    OnboardingViewMB()
                        .transition(.scale)
                        .zIndex(1)
                } else {
                    ZStack(alignment: .bottom) {
                        // Background handled above
                        
                        TabView(selection: $currentTab) {
                            HomeViewMB()
                                .tag(TabMB.home)
                            
                            JournalViewMB()
                                .tag(TabMB.journal)
                            
                            AddHabitViewMB()
                                .tag(TabMB.add)
                            
                            StatsViewMB()
                                .tag(TabMB.stats)
                            
                            SettingsViewMB()
                                .tag(TabMB.settings)
                        }
                        .toolbarBackground(.hidden, for: .tabBar)
                        .background(Color.clear)
                        
                        CustomTabBarMB(currentTab: $currentTab)
                    }
                    .transition(.opacity)
                }
            }
        }
        .environmentObject(viewModel)
        .environmentObject(viewModel.themeManager)
        .environmentObject(storeManager)
        .preferredColorScheme(.dark) // Force Dark Mode globally
    }
    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
}

#Preview {
    MainViewMB()
}
