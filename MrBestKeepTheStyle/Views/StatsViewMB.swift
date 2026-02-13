import SwiftUI

struct StatsViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        NavigationView {
            ZStack {
                GlowBackgroundMB()
                
                VStack(spacing: 0) {
                    HeaderMB(title: "Statistics", subtitle: "Analyze your performance")
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Main Progress Card
                            VStack {
                                Text("Total Improvement")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Text("\(Int(viewModel.improvementPercentage))%")
                                    .font(.system(size: 60, weight: .bold, design: .rounded))
                                    .foregroundColor(themeManager.secondaryColor)
                                    .shadow(color: themeManager.secondaryColor.opacity(0.5), radius: 10)
                                
                                ProgressView(value: viewModel.improvementPercentage, total: 100)
                                    .accentColor(themeManager.primaryColor)
                                    .padding(.horizontal, 40)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            
                            // Grid Stats
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                StatCardMB(
                                    title: "Good Habits",
                                    value: "\(viewModel.goodHabitsCount)",
                                    subtitle: "Building",
                                    icon: "arrow.up.circle.fill",
                                    color: .green
                                )
                                
                                StatCardMB(
                                    title: "Bad Habits",
                                    value: "\(viewModel.badHabitsCount)",
                                    subtitle: "Breaking",
                                    icon: "arrow.down.circle.fill",
                                    color: .red
                                )
                                
                                StatCardMB(
                                    title: "Completion",
                                    value: "High", // Dynamic text based on actual logic
                                    subtitle: "Consistency",
                                    icon: "chart.bar.fill",
                                    color: themeManager.primaryColor
                                )
                                
                                StatCardMB(
                                    title: "Insights",
                                    value: "\(viewModel.motivationalBlocks.count)+",
                                    subtitle: "Unlocked",
                                    icon: "lightbulb.fill",
                                    color: .yellow
                                )
                            }
                            .padding(.horizontal)
                            
                            // Global Insights Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Global Insights")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        InfoCardMB(title: "Morning Routine", content: "Over 40% of adults try to improve their morning routine.", category: "Statistics")
                                            .frame(width: 250)
                                        
                                        InfoCardMB(title: "Phone Overuse", content: "Most common bad habit reported worldwide.", category: "Statistics")
                                            .frame(width: 250)
                                            
                                        InfoCardMB(title: "Fitness Boom", content: "Top growing habit worldwide: fitness and health.", category: "Trends")
                                            .frame(width: 250)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    StatsViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
        .background(Color.black)
}
