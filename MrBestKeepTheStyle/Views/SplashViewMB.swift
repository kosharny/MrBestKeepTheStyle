import SwiftUI

struct SplashViewMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    @State private var progress: CGFloat = 0.0
    @State private var displayedPercentage: Int = 0
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var glowOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            GlowBackgroundMB()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo/Title with glow effect
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    themeManager.primaryColor.opacity(0.2),
                                    themeManager.secondaryColor.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .opacity(glowOpacity)
                        .blur(radius: 30)
                    
                    // App Title
                    VStack(spacing: 12) {
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                    }
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                Spacer()
                
                // Loading Progress
                VStack(spacing: 20) {
                    // Progress Bar
                    VStack(spacing: 12) {
                        // Percentage text above bar
                        Text("\(displayedPercentage)%")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // Progress bar container
                        ZStack(alignment: .leading) {
                            // Background bar
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 280, height: 8)
                            
                            // Progress bar
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            themeManager.primaryColor,
                                            themeManager.secondaryColor
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 280 * progress, height: 8)
                                .shadow(color: themeManager.primaryColor.opacity(0.6), radius: 10)
                        }
                    }
                    
                    // Loading text
                    Text("Loading...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(isAnimating ? 0.3 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            // Animate logo entrance
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Animate glow
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowOpacity = 1.0
            }
            
            // Start loading text animation
            isAnimating = true
            
            // Animate progress with smooth percentage counter
            withAnimation(.easeInOut(duration: 2.5)) {
                progress = 1.0
            }
            
            // Smooth percentage counter animation
            Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
                if displayedPercentage < Int(progress * 100) {
                    displayedPercentage += 1
                } else if progress >= 1.0 && displayedPercentage >= 100 {
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    SplashViewMB()
        .environmentObject(ThemeManagerMB())
}
