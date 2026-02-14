import SwiftUI

enum TabMB {
    case home
    case journal
    case add
    case stats
    case settings
}

struct CustomTabBarMB: View {
    @Binding var currentTab: TabMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @State private var isAddButtonPressed = false
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house.fill", tab: .home, currentTab: $currentTab)
            TabBarButton(icon: "book.fill", tab: .journal, currentTab: $currentTab)
            
            // Central Add Button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAddButtonPressed = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isAddButtonPressed = false
                        currentTab = .add
                    }
                }
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(
                        width: (isAddButtonPressed || currentTab == .add) ? 60 : 50,
                        height: (isAddButtonPressed || currentTab == .add) ? 60 : 50
                    )
                    .background(
                        LinearGradient(
                            colors: [themeManager.primaryColor, themeManager.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.5), lineWidth: 4) // Visual border separate from tab
                    )
                    .shadow(color: themeManager.primaryColor.opacity(0.6), radius: 10, x: 0, y: 5)
                    .offset(y: -30) // Lifted higher in the bump
            }
            .contentShape(Rectangle().offset(y: -30))
            .zIndex(1) // Ensure on top
            
            TabBarButton(icon: "chart.bar.fill", tab: .stats, currentTab: $currentTab)
            TabBarButton(icon: "gearshape.fill", tab: .settings, currentTab: $currentTab)
        }
        .offset(y: -8) // Lift buttons inside the capsule
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(
            ZStack {
                TabBarCurveShape(centerX: 0)
                    .fill(Color(hex: "1a2332")) // Dark blue-gray to match gradient
                
                TabBarCurveShape(centerX: 0)
                    .stroke(themeManager.primaryColor, lineWidth: 2)
            }
            .shadow(color: themeManager.primaryColor.opacity(0.3), radius: 15, x: 0, y: 5)
        )
        .frame(height: 70)
        .frame(maxWidth: 350)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let icon: String
    let tab: TabMB
    @Binding var currentTab: TabMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var isSelected: Bool {
        currentTab == tab
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                currentTab = tab
            }
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? themeManager.secondaryColor : .gray)
                
                if isSelected {
                    Circle()
                        .fill(themeManager.secondaryColor)
                        .frame(width: 5, height: 5)
                        .offset(y: 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        VStack {
            Spacer()
            CustomTabBarMB(currentTab: .constant(.home))
                .environmentObject(ViewModelMB().themeManager)
        }
    }
}
