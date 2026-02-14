import SwiftUI

struct HomeViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    @State private var showArticles = false
    @State private var showInfographics = false
    @State private var selectedArticle: MotivationModelMB?
    @State private var showQuiz = false
    
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
                            Text("Day \(viewModel.daysSinceInstall)")
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
                    
                    // Readiness Quiz Card
                    Button(action: { showQuiz = true }) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: viewModel.readinessQuiz.isCompleted ? "checkmark.seal.fill" : "questionmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Readiness Quiz")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text(viewModel.readinessQuiz.isCompleted ? "View your results" : "Discover your motivation level")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(themeManager.secondaryColor)
                            }
                            
                            if viewModel.readinessQuiz.isCompleted {
                                // Show Results
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Your Level")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(viewModel.readinessQuiz.readinessLevel)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(themeManager.secondaryColor)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Score")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text("\(viewModel.readinessQuiz.percentage)%")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.top, 5)
                            } else {
                                // Call to Action
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    
                                    Text("Take the quiz to assess your readiness for change")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    LinearGradient(
                                        colors: [themeManager.primaryColor.opacity(0.5), themeManager.secondaryColor.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: themeManager.primaryColor.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
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
                        Text("Motivation")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.motivationalBlocks.shuffled().prefix(Int.random(in: 3...4))) { article in
                                    ArticleCardMB(article: article)
                                        .frame(width: 280, height: 120)
                                        .onTapGesture {
                                            selectedArticle = article
                                        }
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
            
            // Custom Modal Overlay for Article Detail
            if let article = selectedArticle {
                ZStack {
                    // Background overlay - tap to dismiss
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedArticle = nil
                            }
                        }
                    
                    // Centered Article Card
                    VStack(alignment: .leading, spacing: 15) {
                        // Close button
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedArticle = nil
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        // Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        
                        // Title
                        VStack(alignment: .leading, spacing: 6) {
                            Text(article.subtitle)
                                .font(.caption)
                                .foregroundColor(themeManager.secondaryColor)
                            
                            Text(article.title)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(2)
                        }
                        
                        // Content in ScrollView
                        ScrollView {
                            Text(article.content)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                        .frame(height: 180)
                    }
                    .padding(20)
                    .frame(width: 340, height: 380)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(hex: "1a1a2e"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
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
                    .transition(.scale.combined(with: .opacity))
                }
                .zIndex(100)
            }
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
        .sheet(isPresented: $showQuiz) {
            ReadinessQuizViewMB()
                .environmentObject(viewModel)
                .environmentObject(themeManager)
        }
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
