import SwiftUI
import StoreKit

struct OnboardingViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    @State private var currentPage = 0
    @State private var imageScale: CGFloat = 0.8
    @State private var imageOpacity: Double = 0
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Animated Image area
                ZStack {
                    if currentPage == 0 {
                        Image(systemName: "stairs")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [themeManager.secondaryColor, themeManager.primaryColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: themeManager.secondaryColor.opacity(0.5), radius: 30)
                    } else if currentPage == 1 {
                        Image(systemName: "link.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.red, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .red.opacity(0.5), radius: 30)
                    } else if currentPage == 2 {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .yellow.opacity(0.5), radius: 30)
                    } else {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: themeManager.primaryColor.opacity(0.5), radius: 30)
                    }
                }
                .scaleEffect(imageScale)
                .opacity(imageOpacity)
                
                Spacer()
                
                // Modern Bottom Card
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(getTitle(for: currentPage))
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, themeManager.secondaryColor.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text(getSubtitle(for: currentPage))
                            .font(.body)
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    
                    // Modern Progress Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            Capsule()
                                .fill(index == currentPage ? themeManager.secondaryColor : Color.white.opacity(0.2))
                                .frame(width: index == currentPage ? 30 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    // Modern Gradient Button
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            imageScale = 0.8
                            imageOpacity = 0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if currentPage < 3 {
                                currentPage += 1
                                if currentPage == 2 {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        requestReview()
                                    }
                                }
                            } else {
                                viewModel.completeOnboarding()
                            }
                            
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                imageScale = 1.0
                                imageOpacity = 1.0
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage == 3 ? "BECOME MRBEST" : "CONTINUE")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: themeManager.primaryColor.opacity(0.5), radius: 15, x: 0, y: 8)
                    }
                }
                .padding(30)
                .background(
                    ZStack {
                        // Glassmorphism effect
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.black.opacity(0.6))
                            .blur(radius: 0.5)
                        
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [themeManager.secondaryColor.opacity(0.3), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: Color.black.opacity(0.5), radius: 30, x: 0, y: -10)
                )
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                imageScale = 1.0
                imageOpacity = 1.0
            }
        }
    }
    
    func getTitle(for index: Int) -> String {
        switch index {
        case 0: return "Build Strong Habits"
        case 1: return "Break Weak Patterns"
        case 2: return "We Need Feedback"
        case 3: return "Become MrBest"
        default: return ""
        }
    }
    
    func getSubtitle(for index: Int) -> String {
        switch index {
        case 0: return "Consistency is key to unlocking your full potential. Start small, dream big."
        case 1: return "Identify the loops that hold you back and crush them with new, empowering routines."
        case 2: return "Your opinion matters. Help us improve keeping the style."
        case 3: return "Join the elite. Master your life. Your journey starts now."
        default: return ""
        }
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    OnboardingViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
}
