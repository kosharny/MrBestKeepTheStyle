import SwiftUI

struct InfoCardMB: View {
    let title: String
    let content: String
    let category: String
    
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.secondaryColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(themeManager.secondaryColor.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
            }
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(
                            colors: [themeManager.primaryColor.opacity(0.5), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1)
                )
        )
    }
}

#Preview {
    InfoCardMB(
        title: "Dopamine Control",
        content: "Your brain seeks cheap dopamine. Social media, sugar, distractions. By resisting these urges, you reset your baseline.",
        category: "Neuroscience"
    )
    .environmentObject(ThemeManagerMB())
    .padding()
    .background(Color.black)
}
