import SwiftUI

struct DetailsViewMB: View {
    var habit: HabitModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @EnvironmentObject var viewModel: ViewModelMB
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 0) {
                HeaderMB(title: habit.title, subtitle: habit.type == .build ? "Building Habit" : "Quitting Habit", showBackButton: true)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Progress Header
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 20)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(habit.progress))
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: [themeManager.primaryColor, themeManager.secondaryColor]),
                                            center: .center
                                        ),
                                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                
                                VStack {
                                    Text("\(Int(habit.progress * 100))%")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Complete")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(height: 200)
                            .padding(.top)
                            
                            HStack(spacing: 40) {
                                VStack {
                                    Text("\(habit.currentStreak)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Current Streak")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack {
                                    Text("\(habit.targetDays)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Goal Days")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 10) {
                            Text("WHY")
                                .font(.headline)
                                .foregroundColor(themeManager.secondaryColor)
                            
                            Text(habit.description)
                                .font(.body)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        // Reflection Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("REFLECTION")
                                .font(.headline)
                                .foregroundColor(themeManager.secondaryColor)
                            
                            Text(habit.type == .build ? "How does performing this habit make you feel about your identity?" : "What triggers the urge to do this? Identify the cue.")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.white.opacity(0.8))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(themeManager.secondaryColor.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        
                        // Calendar / History Placeholder
                        VStack(alignment: .leading, spacing: 10) {
                            Text("HISTORY")
                                .font(.headline)
                                .foregroundColor(themeManager.secondaryColor)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                                ForEach(0..<30) { index in
                                    // Pseudo calendar visualization
                                    Circle()
                                        .fill(habit.completedDays.count > index ? themeManager.primaryColor : Color.white.opacity(0.1))
                                        .frame(height: 30)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                viewModel.resetStreak(habit)
                             }) {
                                 Text("Reset Streak")
                                     .fontWeight(.bold)
                                     .foregroundColor(.orange)
                                     .padding()
                                     .frame(maxWidth: .infinity)
                                     .background(Color.orange.opacity(0.1))
                                     .cornerRadius(15)
                             }
                            
                            Button(action: {
                                viewModel.deleteHabit(habit)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Delete Habit")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top)
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    DetailsViewMB(
        habit: HabitModelMB(
            title: "Meditation",
            description: "20 minutes daily for focus.",
            type: .build,
            targetDays: 30,
            startDate: Date(),
            completedDays: [Date(), Date()],
            notes: ""
        )
    )
    .environmentObject(ViewModelMB())
    .environmentObject(ThemeManagerMB())
}
