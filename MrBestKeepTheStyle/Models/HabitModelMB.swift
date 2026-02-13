import Foundation

enum HabitTypeMB: String, Codable, CaseIterable {
    case build
    case quit
}

struct HabitModelMB: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var type: HabitTypeMB
    var targetDays: Int
    var startDate: Date
    var completedDays: [Date]
    var notes: String
    var isArchived: Bool = false
    
    var currentStreak: Int {
        guard !completedDays.isEmpty else { return 0 }
        
        let sortedDays = completedDays.sorted(by: >)
        var streak = 0
        let calendar = Calendar.current
        
        for (index, date) in sortedDays.enumerated() {
            if index == 0 {
                // First date should be today or yesterday
                let daysDiff = calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
                if daysDiff > 1 { return 0 }
                streak = 1
            } else {
                let previousDate = sortedDays[index - 1]
                let daysDiff = calendar.dateComponents([.day], from: date, to: previousDate).day ?? 0
                if daysDiff == 1 {
                    streak += 1
                } else {
                    break
                }
            }
        }
        return streak
    }
    
    var progress: Double {
        return Double(completedDays.count) / Double(targetDays)
    }
    
    var progressPercentage: Double {
        guard targetDays > 0 else { return 0 }
        return min(Double(completedDays.count) / Double(targetDays) * 100, 100)
    }
    
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDays.contains { calendar.isDate($0, inSameDayAs: Date()) }
    }
}

struct JournalEntryMB: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var text: String
    var moodScore: Int // 1-10
}

struct MotivationModelMB: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var content: String
    var imageName: String
}

struct InsightModelMB: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var category: String
}
