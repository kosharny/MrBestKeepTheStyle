import Foundation

struct ReadinessQuizMB: Codable {
    var id: UUID = UUID()
    var questions: [QuestionMB]
    var completedDate: Date?
    var score: Int?
    
    var isCompleted: Bool {
        return completedDate != nil
    }
    
    var readinessLevel: String {
        guard let score = score else { return "Not Taken" }
        let maxScore = questions.count * 4 // Each question has 5 options (0-4 points)
        let percentage = Double(score) / Double(maxScore) * 100
        
        switch percentage {
        case 80...100:
            return "Highly Ready"
        case 60..<80:
            return "Ready"
        case 40..<60:
            return "Moderately Ready"
        case 20..<40:
            return "Getting Started"
        default:
            return "Just Beginning"
        }
    }
    
    var readinessColor: String {
        guard let score = score else { return "gray" }
        let maxScore = questions.count * 4 // Each question has 5 options (0-4 points)
        let percentage = Double(score) / Double(maxScore) * 100
        
        switch percentage {
        case 80...100:
            return "green"
        case 60..<80:
            return "blue"
        case 40..<60:
            return "yellow"
        case 20..<40:
            return "orange"
        default:
            return "red"
        }
    }
    
    var percentage: Int {
        guard let score = score else { return 0 }
        let maxScore = questions.count * 4
        return Int(round(Double(score) / Double(maxScore) * 100))
    }
}

struct QuestionMB: Codable, Identifiable {
    var id: UUID = UUID()
    var question: String
    var options: [String]
    var selectedAnswer: Int?
    
    var isAnswered: Bool {
        return selectedAnswer != nil
    }
}

extension ReadinessQuizMB {
    static func createDefaultQuiz() -> ReadinessQuizMB {
        return ReadinessQuizMB(
            questions: [
                QuestionMB(
                    question: "How committed are you to making positive changes in your life?",
                    options: [
                        "Not committed at all",
                        "Slightly committed",
                        "Moderately committed",
                        "Very committed",
                        "Extremely committed"
                    ]
                ),
                QuestionMB(
                    question: "How often do you think about improving yourself?",
                    options: [
                        "Rarely or never",
                        "Once a month",
                        "Once a week",
                        "Several times a week",
                        "Daily"
                    ]
                ),
                QuestionMB(
                    question: "When faced with challenges, how do you typically respond?",
                    options: [
                        "I give up easily",
                        "I struggle but eventually quit",
                        "I keep trying with mixed results",
                        "I persist until I find a solution",
                        "I see challenges as opportunities to grow"
                    ]
                ),
                QuestionMB(
                    question: "How willing are you to step out of your comfort zone?",
                    options: [
                        "Not willing at all",
                        "Rarely willing",
                        "Sometimes willing",
                        "Often willing",
                        "Always seeking new challenges"
                    ]
                ),
                QuestionMB(
                    question: "Do you have clear goals for your personal development?",
                    options: [
                        "No goals at all",
                        "Vague ideas",
                        "Some general goals",
                        "Clear short-term goals",
                        "Clear short and long-term goals"
                    ]
                ),
                QuestionMB(
                    question: "How do you handle setbacks in your journey?",
                    options: [
                        "I feel defeated and stop",
                        "I take a long break",
                        "I pause and reconsider",
                        "I learn and adjust my approach",
                        "I use them as fuel to push harder"
                    ]
                ),
                QuestionMB(
                    question: "How much time are you willing to invest in self-improvement daily?",
                    options: [
                        "No time",
                        "Less than 15 minutes",
                        "15-30 minutes",
                        "30-60 minutes",
                        "More than 1 hour"
                    ]
                )
            ]
        )
    }
}
