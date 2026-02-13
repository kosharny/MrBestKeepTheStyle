import SwiftUI

struct PremiumBannerMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Unlock Full Potential")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Get exclusive themes & unlimited stats")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("UPGRADE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(themeManager.secondaryColor)
                    .foregroundColor(.black)
                    .cornerRadius(20)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(
                        colors: [Color(hex: "FFD700").opacity(0.3), Color(hex: "4169E1").opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(hex: "FFD700").opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    PremiumBannerMB(action: {})
        .environmentObject(ThemeManagerMB())
        .padding()
        .background(Color.black)
}
