import SwiftUI

struct CustomButtonMB: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isPrimary: Bool = true
    var colorOverride: Color? = nil
    
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Group {
                    if isPrimary {
                        LinearGradient(
                            colors: [colorOverride ?? themeManager.primaryColor, (colorOverride ?? themeManager.primaryColor).opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.white.opacity(0.1)
                    }
                }
            )
            .cornerRadius(12)
            .shadow(color: isPrimary ? themeManager.primaryColor.opacity(0.5) : Color.clear, radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isPrimary ? Color.white.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        CustomButtonMB(title: "Get Started", icon: "arrow.right", action: {})
            .environmentObject(ThemeManagerMB())
        CustomButtonMB(title: "Secondary Action", icon: nil, action: {}, isPrimary: false)
            .environmentObject(ThemeManagerMB())
    }
    .background(Color.black)
}
