import SwiftUI

struct ReadinessQuizViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var showResult = false
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text("Readiness Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.clear)
                }
                .padding()
                
                if showResult {
                    // Result View
                    resultView
                } else {
                    // Quiz View
                    quizView
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    var quizView: some View {
        VStack(spacing: 30) {
            // Progress
            VStack(spacing: 10) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of \(viewModel.readinessQuiz.questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(viewModel.readinessQuiz.questions.count))
                    }
                }
                .frame(height: 8)
                .padding(.horizontal)
            }
            
            ScrollView {
                VStack(spacing: 25) {
                    // Question
                    Text(viewModel.readinessQuiz.questions[currentQuestionIndex].question)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Options
                    VStack(spacing: 15) {
                        ForEach(Array(viewModel.readinessQuiz.questions[currentQuestionIndex].options.enumerated()), id: \.offset) { index, option in
                            Button(action: {
                                selectAnswer(index)
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    if viewModel.readinessQuiz.questions[currentQuestionIndex].selectedAnswer == index {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(themeManager.secondaryColor)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            viewModel.readinessQuiz.questions[currentQuestionIndex].selectedAnswer == index ?
                                            Color.white.opacity(0.15) : Color.white.opacity(0.05)
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            viewModel.readinessQuiz.questions[currentQuestionIndex].selectedAnswer == index ?
                                            themeManager.secondaryColor : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Navigation Buttons
            HStack(spacing: 15) {
                if currentQuestionIndex > 0 {
                    Button(action: {
                        withAnimation {
                            currentQuestionIndex -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                
                Button(action: {
                    if currentQuestionIndex < viewModel.readinessQuiz.questions.count - 1 {
                        withAnimation {
                            currentQuestionIndex += 1
                        }
                    } else {
                        completeQuiz()
                    }
                }) {
                    HStack {
                        Text(currentQuestionIndex < viewModel.readinessQuiz.questions.count - 1 ? "Next" : "Finish")
                        if currentQuestionIndex < viewModel.readinessQuiz.questions.count - 1 {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [themeManager.primaryColor, themeManager.secondaryColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: themeManager.primaryColor.opacity(0.5), radius: 10)
                }
                .disabled(!viewModel.readinessQuiz.questions[currentQuestionIndex].isAnswered)
                .opacity(viewModel.readinessQuiz.questions[currentQuestionIndex].isAnswered ? 1.0 : 0.5)
            }
            .padding()
        }
    }
    
    var resultView: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Trophy Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [themeManager.primaryColor.opacity(0.3), themeManager.secondaryColor.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundColor(themeManager.secondaryColor)
                }
                .padding(.top, 40)
                
                // Result Title
                Text("Your Readiness Level")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Readiness Level
                Text(viewModel.readinessQuiz.readinessLevel)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(themeManager.secondaryColor)
                
                // Score
                Text("\(viewModel.readinessQuiz.percentage)%")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                // Message
                VStack(alignment: .leading, spacing: 15) {
                    Text(getResultMessage())
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        retakeQuiz()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Retake Quiz")
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [themeManager.primaryColor, themeManager.secondaryColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: themeManager.primaryColor.opacity(0.5), radius: 10)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
    
    func selectAnswer(_ index: Int) {
        viewModel.readinessQuiz.questions[currentQuestionIndex].selectedAnswer = index
    }
    
    func completeQuiz() {
        // Calculate score
        let score = viewModel.readinessQuiz.questions.compactMap { $0.selectedAnswer }.reduce(0, +)
        viewModel.readinessQuiz.score = score
        viewModel.readinessQuiz.completedDate = Date()
        
        withAnimation {
            showResult = true
        }
    }
    
    func retakeQuiz() {
        viewModel.readinessQuiz = ReadinessQuizMB.createDefaultQuiz()
        currentQuestionIndex = 0
        withAnimation {
            showResult = false
        }
    }
    
    func getResultMessage() -> String {
        guard let score = viewModel.readinessQuiz.score else { return "" }
        let maxScore = viewModel.readinessQuiz.questions.count * 4 // Each question has 5 options (0-4 points)
        let percentage = Double(score) / Double(maxScore) * 100
        
        switch percentage {
        case 80...100:
            return "Excellent! You're highly motivated and ready to transform your life. Your commitment and mindset are strong foundations for success. Keep this momentum going!"
        case 60..<80:
            return "Great! You have a solid foundation and readiness for change. With continued focus and dedication, you're well on your way to achieving your goals."
        case 40..<60:
            return "Good start! You're moderately ready for change. Focus on building stronger habits and commitment. Small consistent steps will help you progress."
        case 20..<40:
            return "You're taking the first steps! Building readiness takes time. Start with small, achievable goals and gradually increase your commitment to change."
        default:
            return "Every journey begins with a single step. Use this app to build your motivation and readiness. Start small and be patient with yourself."
        }
    }
}

#Preview {
    ReadinessQuizViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
}
