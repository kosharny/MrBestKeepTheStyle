import SwiftUI

struct AboutViewMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 30) {
                Image("mainLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                
                
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
            }
        }
    }
}

#Preview {
    AboutViewMB()
        .environmentObject(ThemeManagerMB())
}
