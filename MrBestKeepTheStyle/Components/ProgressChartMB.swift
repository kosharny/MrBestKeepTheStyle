import SwiftUI

struct ProgressChartMB: View {
    let buildHabitsCount: Int
    let quitHabitsCount: Int
    let buildCompleted: Int
    let quitCompleted: Int
    
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var buildPercentage: Double {
        guard buildHabitsCount > 0 else { return 0 }
        return Double(buildCompleted) / Double(buildHabitsCount) * 100
    }
    
    var quitPercentage: Double {
        guard quitHabitsCount > 0 else { return 0 }
        return Double(quitCompleted) / Double(quitHabitsCount) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Progress Overview")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                // Build Habits Bar
                VStack(spacing: 10) {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 150)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 60, height: max(150 * CGFloat(buildPercentage / 100), 10))
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(Int(buildPercentage))%")
                            .font(.headline)
                            .foregroundColor(themeManager.secondaryColor)
                        
                        Text("Build")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(buildCompleted)/\(buildHabitsCount)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Quit Habits Bar
                VStack(spacing: 10) {
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 60, height: 150)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [.red, .orange],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 60, height: max(150 * CGFloat(quitPercentage / 100), 10))
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(Int(quitPercentage))%")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        Text("Quit")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(quitCompleted)/\(quitHabitsCount)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Stats Summary
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(themeManager.secondaryColor)
                            .frame(width: 8, height: 8)
                        Text("Building Good Habits")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                        Text("Quitting Bad Habits")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    Text("Total: \(buildHabitsCount + quitHabitsCount) habits")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}

#Preview {
    ProgressChartMB(
        buildHabitsCount: 5,
        quitHabitsCount: 3,
        buildCompleted: 3,
        quitCompleted: 2
    )
    .environmentObject(ThemeManagerMB())
    .padding()
    .background(Color.black)
}
