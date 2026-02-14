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
                    .frame(height: 60)
                
                let imageName: String = {
                    if currentPage == 0 { return "onboarding_welcome" }
                    else if currentPage == 1 { return "onboarding_habits" }
                    else if currentPage == 2 { return "onboarding_journal" }
                    else { return "onboarding_progress" }
                }()

                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [
                                    themeManager.primaryColor.opacity(0.15),
                                    themeManager.secondaryColor.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 290, height: 290)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))

                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    themeManager.primaryColor.opacity(0.6),
                                    themeManager.secondaryColor.opacity(0.6),
                                    themeManager.primaryColor.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                }
                .frame(width: 290, height: 290)
                .shadow(color: themeManager.primaryColor.opacity(0.3), radius: 30, x: 0, y: 10)
                .scaleEffect(imageScale)
                .opacity(imageOpacity)
                .padding(.bottom, 60)
                
                VStack(alignment: .leading, spacing: 28) {
                    // Title and Subtitle
                    VStack(alignment: .leading, spacing: 14) {
                        Text(getTitle(for: currentPage))
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, themeManager.secondaryColor.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .lineLimit(2)
                        
                        Text(getSubtitle(for: currentPage))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Modern Progress Indicator
                    HStack(spacing: 10) {
                        ForEach(0..<4) { index in
                            Capsule()
                                .fill(
                                    index == currentPage ?
                                    LinearGradient(
                                        colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.2), Color.white.opacity(0.2)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: index == currentPage ? 40 : 10, height: 10)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.vertical, 4)
                    
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
                        HStack(spacing: 12) {
                            Text(currentPage == 3 ? "BECOME MRBEST" : "CONTINUE")
                                .font(.system(size: 17, weight: .bold))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            LinearGradient(
                                colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: themeManager.primaryColor.opacity(0.6), radius: 20, x: 0, y: 10)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 36)
                .background(
                    ZStack {
                        // Glassmorphism effect
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.black.opacity(0.65))
                            .blur(radius: 0.5)
                        
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        themeManager.secondaryColor.opacity(0.4),
                                        themeManager.primaryColor.opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                    .shadow(color: Color.black.opacity(0.6), radius: 40, x: 0, y: -15)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
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
