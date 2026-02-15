import SwiftUI

struct InfographicsViewMB: View {
    @EnvironmentObject var themeManager: ThemeManagerMB
    @Environment(\.dismiss) var dismiss
    
    let infographics: [InfographicDataMB] = [
        // Quit Habits Success Stories
        InfographicDataMB(
            title: "Longest Smoking Cessation",
            value: "45 years",
            description: "Record holder quit smoking and maintained sobriety for 45+ years",
            icon: "smoke.fill",
            color: .red,
            type: .quit
        ),
        InfographicDataMB(
            title: "Alcohol Sobriety Record",
            value: "30+ years",
            description: "Millions worldwide maintain decades of sobriety through support groups",
            icon: "drop.fill",
            color: .orange,
            type: .quit
        ),
        InfographicDataMB(
            title: "Social Media Detox",
            value: "5 years",
            description: "Growing movement of people who quit social media permanently",
            icon: "iphone.slash",
            color: .red,
            type: .quit
        ),
        InfographicDataMB(
            title: "Sugar-Free Lifestyle",
            value: "10+ years",
            description: "Health enthusiasts maintain sugar-free diets for over a decade",
            icon: "cube.fill",
            color: .orange,
            type: .quit
        ),
        
        // Build Habits Success Stories
        InfographicDataMB(
            title: "Daily Exercise Streak",
            value: "20+ years",
            description: "Athletes maintain daily exercise routines for decades",
            icon: "figure.run",
            color: .green,
            type: .build
        ),
        InfographicDataMB(
            title: "Meditation Practice",
            value: "40 years",
            description: "Monks and practitioners meditate daily for 40+ years",
            icon: "brain.head.profile",
            color: .cyan,
            type: .build
        ),
        InfographicDataMB(
            title: "Daily Reading Habit",
            value: "50+ years",
            description: "Warren Buffett reads 500+ pages daily for over 50 years",
            icon: "book.fill",
            color: .green,
            type: .build
        ),
        InfographicDataMB(
            title: "Cold Showers",
            value: "15 years",
            description: "Wim Hof method practitioners take cold showers daily for years",
            icon: "snowflake",
            color: .cyan,
            type: .build
        ),
        InfographicDataMB(
            title: "Journaling Streak",
            value: "25 years",
            description: "Writers and thinkers journal daily for decades",
            icon: "pencil",
            color: .green,
            type: .build
        ),
        InfographicDataMB(
            title: "Early Rising (5 AM)",
            value: "30 years",
            description: "CEOs and high performers wake at 5 AM for 30+ years",
            icon: "sunrise.fill",
            color: .cyan,
            type: .build
        )
    ]
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    
                    Text("World Statistics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.secondaryColor)
                    }
                }
                .padding()
                
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(infographics) { infographic in
                            InfographicCardMB(data: infographic)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white.opacity(0.5))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}

struct InfographicCardMB: View {
    let data: InfographicDataMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(data.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: data.icon)
                    .font(.title2)
                    .foregroundColor(data.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(data.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(data.value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(data.color)
                
                Text(data.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(data.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InfographicDataMB: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let description: String
    let icon: String
    let color: Color
    let type: HabitTypeMB
}

#Preview {
    InfographicsViewMB()
        .environmentObject(ThemeManagerMB())
}
