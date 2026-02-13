import SwiftUI

struct HabitCardMB: View {
    let habit: HabitModelMB
    let onToggle: () -> Void
    
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return habit.completedDays.contains { calendar.isDate($0, inSameDayAs: Date()) }
    }
    
    var cardColor: Color {
        habit.type == .build ? themeManager.secondaryColor : Color.red
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(habit.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(cardColor)
                        .font(.caption)
                    Text("\(habit.currentStreak) day streak")
                        .font(.caption2)
                        .foregroundColor(cardColor)
                }
            }
            
            Spacer()
            
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(cardColor, lineWidth: 2)
                        .frame(width: 40, height: 40)
                    
                    if isCompletedToday {
                        Circle()
                            .fill(cardColor)
                            .frame(width: 30, height: 30)
                            .shadow(color: cardColor.opacity(0.8), radius: 10)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isCompletedToday ? cardColor.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: isCompletedToday ? cardColor.opacity(0.2) : Color.clear, radius: 10)
        )
    }
}

#Preview {
    HabitCardMB(
        habit: HabitModelMB(
            title: "Morning Run",
            description: "Run 5km every morning",
            type: .build,
            targetDays: 30,
            startDate: Date(),
            completedDays: [Date()],
            notes: ""
        ),
        onToggle: {}
    )
    .environmentObject(ThemeManagerMB())
    .padding()
    .background(Color.black)
}
