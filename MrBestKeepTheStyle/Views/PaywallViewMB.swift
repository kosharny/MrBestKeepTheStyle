import SwiftUI
import StoreKit

struct PaywallViewMB: View {
    @EnvironmentObject var storeManager: StoreManagerMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(spacing: 30) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "FFD700"))
                            .shadow(color: Color(hex: "FFD700").opacity(0.8), radius: 20)
                        
                        Text("Unlock Premium Style")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            FeatureRow(icon: "paintpalette.fill", text: "Exclusive Royal & Neon Themes")
                            FeatureRow(icon: "chart.bar.xaxis", text: "Advanced Analytics & Unlimited History")
                            FeatureRow(icon: "brain.head.profile", text: "Full Access to Insight Library")
                            FeatureRow(icon: "cloud.fill", text: "Cloud Sync (Coming Soon)")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Products
                        VStack(spacing: 15) {
                            ForEach(storeManager.myProducts, id: \.productIdentifier) { product in
                                Button(action: {
                                    storeManager.purchaseProduct(product: product)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(product.localizedTitle)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                            Text(product.localizedDescription)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(product.priceFormatted())
                                            .fontWeight(.bold)
                                            .padding(8)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                    .background(Color(hex: "4169E1").opacity(0.3)) // Royal Blueish
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(hex: "FFD700"), lineWidth: 1)
                                    )
                                }
                                .foregroundColor(.white)
                            }
                            
                            // Mock Button if no products (Simulator)
                            if storeManager.myProducts.isEmpty {
                                Button(action: {
                                    // Mock Purchase Logic for Simulator
                                    print("Mock Purchase Triggered")
                                }) {
                                    Text("Buy Premium - $1.99 (Sim)")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(themeManager.primaryColor)
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Button("Restore Purchases") {
                            storeManager.restoreProducts()
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top)
                        
                        Text("Recurring billing, cancel anytime.")
                            .font(.caption2)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "2FFFD3"))
                .frame(width: 30)
            Text(text)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

extension SKProduct {
    func priceFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price) ?? ""
    }
}

#Preview {
    PaywallViewMB()
        .environmentObject(StoreManagerMB())
        .environmentObject(ThemeManagerMB())
}
