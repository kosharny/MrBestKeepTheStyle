import SwiftUI
import StoreKit

struct PaywallViewMB: View {
    let theme: AppThemeMB
    
    @StateObject private var store = StoreManagerMB.shared
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManagerMB
    @EnvironmentObject var viewModel: ViewModelMB
    
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    @State private var resultTitle = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 20) {
                    // Theme Preview
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        themeManager.secondaryColor(for: theme),
                                        themeManager.primaryColor(for: theme)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: themeManager.secondaryColor(for: theme).opacity(0.5), radius: 20)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    Text(theme.displayName)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Unlock this exclusive premium theme")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRowMB(
                        icon: "paintpalette.fill",
                        title: "Unique Color Palette",
                        description: "Experience the app in stunning new colors"
                    )
                    
                    FeatureRowMB(
                        icon: "sparkles",
                        title: "Exclusive Visuals",
                        description: "Enhanced UI elements and accents"
                    )
                    
                    FeatureRowMB(
                        icon: "heart.fill",
                        title: "Support Development",
                        description: "Help us create more amazing content"
                    )
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Purchase Section
                if let product = store.products.first(where: { $0.id == theme.productID }) {
                    VStack(spacing: 16) {
                        // Purchase Button
                        Button {
                            selectedProduct = product
                            showConfirmAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("Unlock for \(product.displayPrice)")
                                    .fontWeight(.bold)
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [themeManager.primaryColor(for: theme), themeManager.secondaryColor(for: theme)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: themeManager.primaryColor(for: theme).opacity(0.3), radius: 10)
                        }
                        
                        // Restore Button
                        Button {
                            Task {
                                await store.restorePurchases()
                                if store.hasAccess(to: theme) {
                                    resultTitle = "Success"
                                    resultMessage = "Your purchases have been restored!"
                                    isSuccess = true
                                    showResultAlert = true
                                } else {
                                    resultTitle = "No Purchases Found"
                                    resultMessage = "We couldn't find any previous purchases for this theme."
                                    isSuccess = false
                                    showResultAlert = true
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 10) {
                        if store.isLoading {
                            ProgressView()
                                .tint(themeManager.primaryColor(for: theme))
                            Text("Loading products...")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        } else {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.yellow)
                            Text("Product not found")
                                .foregroundColor(.white.opacity(0.6))
                            Text("ID: \(theme.productID ?? "nil")")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                            Button("Retry") {
                                Task { await store.fetchProducts() }
                            }
                            .padding(.top, 5)
                        }
                    }
                    .padding()
                }
                
                // Close Button
                Button {
                    dismiss()
                } label: {
                    Text("Not Now")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .background(
                themeManager.backgroundGradient
                    .ignoresSafeArea()
            )
        }
        .customAlert(isPresented: $showConfirmAlert, alert: confirmAlert)
        .customAlert(isPresented: $showResultAlert, alert: resultAlert)
        .task {
            if store.products.isEmpty {
                await store.fetchProducts()
            }
        }
    }
    
    // Confirmation Alert
    var confirmAlert: CustomAlertMB {
        CustomAlertMB(
            title: "Confirm Purchase",
            message: "Unlock \(theme.displayName) for \(selectedProduct?.displayPrice ?? "")?\n\nThis is a one-time purchase.",
            primaryButton: .init(title: "Purchase", isPrimary: true) {
                showConfirmAlert = false
                Task {
                    await performPurchase()
                }
            },
            secondaryButton: .init(title: "Cancel") {
                showConfirmAlert = false
            }
        )
    }
    
    // Result Alert
    var resultAlert: CustomAlertMB {
        CustomAlertMB(
            title: resultTitle,
            message: resultMessage,
            primaryButton: .init(title: "OK", isPrimary: true) {
                showResultAlert = false
                if isSuccess && store.hasAccess(to: theme) {
                    dismiss()
                }
            },
            secondaryButton: nil
        )
    }

    func performPurchase() async {
        guard let product = selectedProduct else { return }
        
        let status = await store.purchase(product)
        
        switch status {
        case .success:
            if store.hasAccess(to: theme) {
                resultTitle = "Success!"
                resultMessage = "\(theme.displayName) has been unlocked. Enjoy!"
                isSuccess = true
                showResultAlert = true
            }
            
        case .cancelled:
            print("User cancelled purchase")
            showResultAlert = false
            
        case .pending:
            resultTitle = "Pending"
            resultMessage = "Your purchase is pending approval."
            isSuccess = false
            showResultAlert = true
            
        case .failed:
            resultTitle = "Purchase Failed"
            resultMessage = "We couldn't complete your purchase. Please try again."
            isSuccess = false
            showResultAlert = true
        }
    }
}

struct FeatureRowMB: View {
    let icon: String
    let title: String
    let description: String
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(themeManager.primaryColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(themeManager.secondaryColor.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    PaywallViewMB(theme: .royalBluePro)
        .environmentObject(ThemeManagerMB())
        .environmentObject(ViewModelMB())
}
