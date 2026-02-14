import SwiftUI

// MARK: - Custom Alert Model
struct CustomAlertMB {
    let title: String
    let message: String
    let primaryButton: CustomAlertButtonMB
    let secondaryButton: CustomAlertButtonMB?
}

// MARK: - Custom Alert Button
struct CustomAlertButtonMB {
    let title: String
    let isPrimary: Bool
    let action: () -> Void
    
    init(title: String, isPrimary: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isPrimary = isPrimary
        self.action = action
    }
}

// MARK: - Custom Alert View
struct CustomAlertViewMB: View {
    let alert: CustomAlertMB
    let dismiss: () -> Void
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Alert card
            VStack(spacing: 20) {
                // Title
                Text(alert.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Message
                Text(alert.message)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                // Buttons
                VStack(spacing: 12) {
                    // Primary button
                    Button(action: {
                        alert.primaryButton.action()
                        dismiss()
                    }) {
                        Text(alert.primaryButton.title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    
                    // Secondary button (if exists)
                    if let secondaryButton = alert.secondaryButton {
                        Button(action: {
                            secondaryButton.action()
                            dismiss()
                        }) {
                            Text(secondaryButton.title)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1a1a2e"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [themeManager.primaryColor.opacity(0.5), themeManager.secondaryColor.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: themeManager.primaryColor.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
}

// MARK: - View Modifier
struct CustomAlertModifierMB: ViewModifier {
    @Binding var isPresented: Bool
    let alert: CustomAlertMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                CustomAlertViewMB(alert: alert) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isPresented = false
                    }
                }
                .environmentObject(themeManager)
                .zIndex(1000)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
}

// MARK: - View Extension
extension View {
    func customAlert(isPresented: Binding<Bool>, alert: CustomAlertMB) -> some View {
        self.modifier(CustomAlertModifierMB(isPresented: isPresented, alert: alert))
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            Text("Preview")
        }
    }
    .customAlert(
        isPresented: .constant(true),
        alert: CustomAlertMB(
            title: "Confirm Purchase",
            message: "Unlock Royal Blue Pro for $2.99?\n\nThis is a one-time purchase.",
            primaryButton: .init(title: "Purchase", isPrimary: true) {
                print("Purchase tapped")
            },
            secondaryButton: .init(title: "Cancel") {
                print("Cancel tapped")
            }
        )
    )
    .environmentObject(ThemeManagerMB())
}
