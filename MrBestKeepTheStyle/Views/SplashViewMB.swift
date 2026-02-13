import SwiftUI

struct SplashViewMB: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        if isActive {
            // This will be handled by the parent view to switch to Onboarding/Main
            Color.clear
        } else {
            ZStack {
                themeManager.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 80))
                        .foregroundColor(themeManager.secondaryColor)
                        .shadow(color: themeManager.secondaryColor, radius: 20)
                    
                    Text("MrBest")
                        .font(.custom("Futura-Bold", size: 40)) // Using system font fallback if specific not avail
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .padding(.top, 10)
                    
                    Text("KEEP THE STYLE")
                        .font(.headline)
                        .foregroundColor(themeManager.primaryColor)
                        .fontWeight(.bold)
                        .tracking(2)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashViewMB()
        .environmentObject(ThemeManagerMB())
}
