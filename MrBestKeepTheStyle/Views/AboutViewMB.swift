import SwiftUI

struct AboutViewMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 30) {
                // Header handled by navigation or parent, but let's add content
                Image(systemName: "crown.fill")
                    .font(.system(size: 80))
                    .foregroundColor(themeManager.secondaryColor)
                    .padding(.top, 50)
                
                Text("MrBest: Keep The Style")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                VStack(spacing: 20) {
                    Text("We believe in the power of identity-based habits. You don't just do things; you become the person who does them.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                    
                    Text("Designed for those who want to level up their life like a game. Structure, discipline, and style.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                }
                
                Spacer()
                
                Text("© 2026 MrBest Inc.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    AboutViewMB()
        .environmentObject(ThemeManagerMB())
}
