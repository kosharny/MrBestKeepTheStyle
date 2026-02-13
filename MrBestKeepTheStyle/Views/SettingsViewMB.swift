import SwiftUI

struct SettingsViewMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    @EnvironmentObject var storeManager: StoreManagerMB
    @EnvironmentObject var viewModel: ViewModelMB
    
    @State private var showingPaywall = false
    @State private var showingAbout = false
    @State private var showingMotivation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlowBackgroundMB()
                
                VStack(spacing: 0) {
                    HeaderMB(title: "Settings", subtitle: "Customize your style")
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            
                            // Premium Banner
                            if !storeManager.purchasedProductIDs.contains("com.mrbest.keepthestyle.royalbluepro") {
                                PremiumBannerMB {
                                    showingPaywall = true
                                }
                                .padding(.horizontal)
                            }
                            
                            // Motivation Hub Link
                            Button(action: { showingMotivation = true }) {
                                HStack {
                                    Image(systemName: "brain.head.profile")
                                        .foregroundColor(themeManager.secondaryColor)
                                    Text("Motivation Hub")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(15)
                            }
                            .padding(.horizontal)
                            
                            // Theme Selection
                            VStack(alignment: .leading, spacing: 10) {
                                Text("THEME")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                ForEach(AppThemeMB.allCases, id: \.self) { theme in
                                    Button(action: {
                                        if theme.isPremium && !storeManager.isPurchased("com.mrbest.keepthestyle." + theme.rawValue.lowercased()) && !storeManager.purchasedProductIDs.contains("com.mrbest.keepthestyle." + theme.rawValue.lowercased()) {
                                             if theme == .standard {
                                                 themeManager.currentTheme = theme
                                             } else {
                                                  themeManager.currentTheme = theme
                                             }
                                        } else {
                                            themeManager.currentTheme = theme
                                        }
                                    }) {
                                        HStack {
                                            Circle()
                                                .fill(themeColor(for: theme))
                                                .frame(width: 20, height: 20)
                                            
                                            Text(theme.displayName)
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                            
                                            if theme == .royalBluePro || theme == .darkNeonPro {
                                                Text("PRO")
                                                    .font(.caption2)
                                                    .fontWeight(.bold)
                                                    .padding(4)
                                                    .background(Color.yellow)
                                                    .foregroundColor(.black)
                                                    .cornerRadius(4)
                                            }
                                            
                                            Spacer()
                                            
                                            if themeManager.currentTheme == theme {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(themeManager.secondaryColor)
                                            }
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(15)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // General
                            VStack(alignment: .leading, spacing: 10) {
                                Text("GENERAL")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                Button(action: { showingAbout = true }) {
                                    SettingRow(icon: "info.circle", title: "About App")
                                }
                                .padding(.horizontal)
                                
                                SettingRow(icon: "envelope", title: "Contact Support")
                                    .padding(.horizontal)
                                
                                SettingRow(icon: "shield", title: "Privacy Policy")
                                    .padding(.horizontal)
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingPaywall) {
                PaywallViewMB()
                    .environmentObject(storeManager)
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showingAbout) {
                AboutViewMB()
                    .environmentObject(themeManager)
            }
            .navigationDestination(isPresented: $showingMotivation) {
                MotivationViewMB()
            }
        }
    }
    
    func themeColor(for theme: AppThemeMB) -> Color {
        switch theme {
        case .standard: return Color(hex: "2563FF")
        case .royalBluePro: return Color(hex: "4169E1")
        case .darkNeonPro: return Color(hex: "FF00FF")
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

#Preview {
    SettingsViewMB()
        .environmentObject(ThemeManagerMB())
        .environmentObject(StoreManagerMB())
        .environmentObject(ViewModelMB())
        .background(Color.black)
}
