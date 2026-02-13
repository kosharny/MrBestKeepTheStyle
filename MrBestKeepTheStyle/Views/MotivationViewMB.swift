import SwiftUI

struct MotivationViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 0) {
                
                // Content
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Header manually here to allow back button if needed, or just layout
                        Text("Motivation Hub")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.top)
                            .shadow(color: themeManager.secondaryColor, radius: 10)
                        
                        Text("Fuel for your journey.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Educational Section
                        Text("Educational Insights")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.educationalBlocks.prefix(5)) { block in
                            InfoCardMB(title: block.title, content: block.content, category: block.category)
                                .padding(.horizontal)
                        }
                        
                        // Motivational Section
                        Text("Deep Dives")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ForEach(viewModel.motivationalBlocks) { block in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(block.title)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text(block.subtitle)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(themeManager.secondaryColor)
                                            .padding(4)
                                            .background(themeManager.secondaryColor.opacity(0.1))
                                            .cornerRadius(4)
                                    }
                                    Spacer()
                                    // Placeholder for image asset name usage
                                    Image(systemName: "brain.head.profile")
                                        .font(.title)
                                        .foregroundColor(themeManager.primaryColor)
                                        .opacity(0.5)
                                }
                                
                                Text(block.content)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(4)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: [themeManager.primaryColor.opacity(0.3), Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
    }
}

#Preview {
    MotivationViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
}
