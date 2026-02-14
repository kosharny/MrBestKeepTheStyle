import SwiftUI
import StoreKit

struct SettingsViewMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    @EnvironmentObject var viewModel: ViewModelMB
    
    @StateObject private var store = StoreManagerMB.shared
    @State private var selectedThemeForPaywall: AppThemeMB?
    @State private var showingAbout = false
    @State private var showRestoreAlert = false
    @State private var restoreMessage = ""
    @State private var restoreTitle = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlowBackgroundMB()
                
                VStack(spacing: 0) {
                    HeaderMB(title: "Settings", subtitle: "Customize your style")
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            
                            // Premium Banner
                            if !viewModel.premiumEnabled {
                                PremiumBannerMB {
                                    selectedThemeForPaywall = .royalBluePro
                                }
                                .padding(.horizontal)
                            }
                            

                            // Theme Selection
                            VStack(alignment: .leading, spacing: 10) {
                                Text("THEME")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                ForEach(AppThemeMB.allCases, id: \.self) { theme in
                                    Button(action: {
                                        if store.hasAccess(to: theme) {
                                            themeManager.currentTheme = theme
                                        } else {
                                            selectedThemeForPaywall = theme
                                        }
                                    }) {
                                        HStack {
                                            Circle()
                                                .fill(themeColor(for: theme))
                                                .frame(width: 20, height: 20)
                                            
                                            Text(theme.displayName)
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                            
                                            if theme.isPremium && !store.hasAccess(to: theme) {
                                                // Lock icon for unpurchased premium themes
                                                Image(systemName: "lock.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            // Show price for unpurchased premium themes
                                            if theme.isPremium && !store.hasAccess(to: theme) {
                                                if let product = store.products.first(where: { $0.id == theme.productID }) {
                                                    Text(product.displayPrice)
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(themeManager.secondaryColor)
                                                } else {
                                                    Text("PRO")
                                                        .font(.caption2)
                                                        .fontWeight(.bold)
                                                        .padding(4)
                                                        .background(Color.yellow)
                                                        .foregroundColor(.black)
                                                        .cornerRadius(4)
                                                }
                                            } else if themeManager.currentTheme == theme {
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
                                
                                Button(action: {
                                    Task {
                                        await store.restorePurchases()
                                        if viewModel.premiumEnabled {
                                            restoreTitle = "Success"
                                            restoreMessage = "Your purchases have been restored!"
                                        } else {
                                            restoreTitle = "No Purchases Found"
                                            restoreMessage = "We couldn't find any previous purchases."
                                        }
                                        showRestoreAlert = true
                                    }
                                }) {
                                    SettingRow(icon: "arrow.clockwise", title: "Restore Purchases")
                                }
                                .padding(.horizontal)
                                
                                Button(action: { showingAbout = true }) {
                                    SettingRow(icon: "info.circle", title: "About App")
                                }
                                .padding(.horizontal)
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(item: $selectedThemeForPaywall) { theme in
                PaywallViewMB(theme: theme)
                    .environmentObject(viewModel)
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showingAbout) {
                AboutViewMB()
                    .environmentObject(themeManager)
            }
            .customAlert(isPresented: $showRestoreAlert, alert: CustomAlertMB(
                title: restoreTitle,
                message: restoreMessage,
                primaryButton: .init(title: "OK", isPrimary: true) { },
                secondaryButton: nil
            ))
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
