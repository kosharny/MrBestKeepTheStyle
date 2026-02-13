import SwiftUI

struct HeaderMB: View {
    let title: String
    var subtitle: String? = nil
    var showBackButton: Bool = false
    var actionIcon: String? = nil
    var action: (() -> Void)? = nil
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            } else {
                // Placeholder to balance layout if needed
                if actionIcon != nil {
                   Spacer().frame(width: 44)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: themeManager.primaryColor, radius: 10)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if let icon = actionIcon, let action = action {
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(themeManager.secondaryColor)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                        .shadow(color: themeManager.secondaryColor.opacity(0.5), radius: 5)
                }
            } else if showBackButton {
                 Spacer().frame(width: 44)
            }
        }
        .padding()
        .background(Color.black.opacity(0.2))
    }
}

#Preview {
    VStack {
        HeaderMB(title: "MrBest Style", subtitle: "Keep growing", actionIcon: "gear", action: {})
            .environmentObject(ViewModelMB().themeManager)
        
        HeaderMB(title: "Details", showBackButton: true)
            .environmentObject(ViewModelMB().themeManager)
    }
    .background(Color.black)
}
