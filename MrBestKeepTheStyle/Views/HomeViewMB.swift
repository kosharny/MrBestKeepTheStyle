import SwiftUI

struct HomeViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    @State private var showArticles = false
    @State private var showInfographics = false
    
    // Grid layout for habits
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Day \(dayOfYear())")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.secondaryColor)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(themeManager.secondaryColor.opacity(0.1))
                                .cornerRadius(8)
                            
                            Text("Keep The Style")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "crown.fill")
                            .font(.largeTitle)
                            .foregroundColor(themeManager.secondaryColor)
                            .shadow(color: themeManager.secondaryColor, radius: 10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Quick Counters
                    HStack(spacing: 15) {
                        CounterCard(
                            title: "Active",
                            count: "\(viewModel.habits.count)",
                            color: .white
                        )
                        CounterCard(
                            title: "Completed",
                            count: "\(viewModel.habits.filter { $0.progress >= 1.0 }.count)",
                            color: themeManager.secondaryColor
                        )
                        CounterCard(
                            title: "Streak",
                            count: "0", // Global streak logic placeholder
                            color: themeManager.primaryColor
                        )
                    }
                    .padding(.horizontal)
                    
                    // Tip of the Day
                    if let insight = viewModel.motivationalBlocks.randomElement() {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(themeManager.secondaryColor)
                                Text("TIP OF THE DAY")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(themeManager.secondaryColor)
                            }
                            
                            Text(insight.content)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(themeManager.secondaryColor.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Progress Chart
                    if !viewModel.habits.isEmpty {
                        let buildHabits = viewModel.habits.filter { $0.type == .build }
                        let quitHabits = viewModel.habits.filter { $0.type == .quit }
                        let buildCompleted = buildHabits.filter { $0.isCompletedToday }.count
                        let quitCompleted = quitHabits.filter { $0.isCompletedToday }.count
                        
                        ProgressChartMB(
                            buildHabitsCount: buildHabits.count,
                            quitHabitsCount: quitHabits.count,
                            buildCompleted: buildCompleted,
                            quitCompleted: quitCompleted
                        )
                        .padding(.horizontal)
                    }
                    
                    // Motivation Articles Preview
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Motivation")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: { showArticles = true }) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.secondaryColor)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.motivationalBlocks.prefix(3)) { article in
                                    ArticleCardMB(article: article)
                                        .frame(width: 280)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Infographics Preview
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("World Statistics")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: { showInfographics = true }) {
                                Text("Explore")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.secondaryColor)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            InfographicPreviewCard(
                                title: "Longest Streaks",
                                value: "45+ years",
                                icon: "flame.fill",
                                color: .orange
                            )
                            
                            InfographicPreviewCard(
                                title: "Success Rate",
                                value: "80%",
                                icon: "chart.line.uptrend.xyaxis",
                                color: themeManager.secondaryColor
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Good Habits
                    if !viewModel.habits.filter({ $0.type == .build }).isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Building Structure")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(viewModel.habits.filter { $0.type == .build }) { habit in
                                    GridHabitCard(habit: habit)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Bad Habits
                    if !viewModel.habits.filter({ $0.type == .quit }).isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Eliminating Weakness")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(viewModel.habits.filter { $0.type == .quit }) { habit in
                                    GridHabitCard(habit: habit)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 120)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear) // Force clear
        }
        .sheet(isPresented: $showArticles) {
            ArticlesViewMB()
                .environmentObject(viewModel)
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showInfographics) {
            InfographicsViewMB()
                .environmentObject(themeManager)
        }
    }
    
    func dayOfYear() -> Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
}

// Sub-components for HomeViewMB

struct CounterCard: View {
    let title: String
    let count: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(count)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct GridHabitCard: View {
    let habit: HabitModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @EnvironmentObject var viewModel: ViewModelMB
    
    @State private var showDetailSheet = false
    
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return habit.completedDays.contains { calendar.isDate($0, inSameDayAs: Date()) }
    }
    
    var accentColor: Color {
        habit.type == .build ? themeManager.secondaryColor : Color.red
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(accentColor.opacity(0.2))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: habit.type == .build ? "arrow.up" : "xmark")
                            .font(.caption)
                            .foregroundColor(accentColor)
                    )
                
                Spacer()
                
                if isCompletedToday {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(accentColor)
                }
            }
            
            Text(habit.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            HStack {
                Text("\(habit.currentStreak) days")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                // Toggle Button Area
                Button(action: {
                     withAnimation {
                         viewModel.toggleHabitCompletion(habit: habit, date: Date())
                     }
                }) {
                    Circle()
                        .stroke(accentColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .overlay(
                             Circle()
                                .fill(isCompletedToday ? accentColor : Color.clear)
                                .padding(4)
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isCompletedToday ? accentColor.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        )
        .onTapGesture {
            showDetailSheet = true
        }
        .sheet(isPresented: $showDetailSheet) {
            HabitDetailSheetMB(habit: habit)
                .environmentObject(viewModel)
                .environmentObject(themeManager)
        }
    }
}

struct InfographicPreviewCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
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
    HomeViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
        .background(Color.black)
}
