import SwiftUI

struct HabitDetailSheetMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @Environment(\.dismiss) var dismiss
    
    let habit: HabitModelMB
    
    @State private var showResetAlert = false
    @State private var showSuccessAnimation = false
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header with close button
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Habit Icon and Title
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: habit.type == .build ? 
                                            [themeManager.primaryColor, themeManager.secondaryColor] :
                                            [.red, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: (habit.type == .build ? themeManager.primaryColor : .red).opacity(0.5), radius: 20)
                            
                            Image(systemName: habit.type == .build ? "arrow.up.circle.fill" : "xmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        
                        Text(habit.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(habit.type == .build ? "Building Habit" : "Quitting Habit")
                            .font(.subheadline)
                            .foregroundColor(habit.type == .build ? themeManager.secondaryColor : .red)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                    }
                    
                    // Stats Cards
                    HStack(spacing: 15) {
                        StatCard(
                            title: "Current Streak",
                            value: "\(habit.currentStreak)",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Progress",
                            value: "\(habit.completedDays.count)/\(habit.targetDays)",
                            icon: "chart.bar.fill",
                            color: themeManager.secondaryColor
                        )
                    }
                    .padding(.horizontal)
                    
                    // Description
                    if !habit.description.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(habit.description)
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    
                    // Progress Bar
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Overall Progress")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(Int(habit.progressPercentage))%")
                                .font(.headline)
                                .foregroundColor(themeManager.secondaryColor)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.1))
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: habit.type == .build ?
                                                [themeManager.primaryColor, themeManager.secondaryColor] :
                                                [.red, .orange],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * CGFloat(habit.progressPercentage / 100))
                            }
                        }
                        .frame(height: 20)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        // Mark Complete Button (only if not completed today)
                        if !habit.isCompletedToday {
                            Button(action: {
                                viewModel.toggleHabitCompletion(habit)
                                showSuccessAnimation = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                    Text("Mark Complete for Today")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(15)
                                .shadow(color: themeManager.primaryColor.opacity(0.5), radius: 15)
                            }
                        }
                        
                        // Reset Button
                        Button(action: {
                            showResetAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .font(.title3)
                                Text("Reset Progress")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.red, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: .red.opacity(0.5), radius: 15)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 20)
            }
            
            // Success Animation
            if showSuccessAnimation {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(themeManager.secondaryColor)
                        
                        Text("Great Job!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .scaleEffect(showSuccessAnimation ? 1.0 : 0.5)
                    .opacity(showSuccessAnimation ? 1.0 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showSuccessAnimation)
                }
            }
        }
        .customAlert(isPresented: $showResetAlert, alert: CustomAlertMB(
            title: "Reset Progress?",
            message: "This will reset all progress for this habit. This action cannot be undone.",
            primaryButton: .init(title: "Reset", isPrimary: true) {
                viewModel.resetHabit(habit)
                dismiss()
            },
            secondaryButton: .init(title: "Cancel") { }
        ))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

#Preview {
    HabitDetailSheetMB(habit: HabitModelMB(
        title: "Morning Run",
        description: "Run 5km every morning to stay healthy",
        type: .build,
        targetDays: 30,
        startDate: Date(),
        completedDays: [Date()],
        notes: ""
    ))
    .environmentObject(ViewModelMB())
    .environmentObject(ThemeManagerMB())
}
