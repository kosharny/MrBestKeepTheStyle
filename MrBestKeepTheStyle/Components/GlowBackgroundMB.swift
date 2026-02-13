import SwiftUI

struct GlowBackgroundMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        ZStack {
            themeManager.backgroundGradient
                .ignoresSafeArea()
            
            // Radial glows removed to match SplashViewMB exactly as requested
            // if needed, we can re-add them with much lower opacity later
        }
    }
}

#Preview {
    GlowBackgroundMB()
        .environmentObject(ThemeManagerMB())
}
