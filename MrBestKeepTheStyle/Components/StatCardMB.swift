import SwiftUI

struct StatCardMB: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                Spacer()
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HStack {
        StatCardMB(title: "Completion", value: "85%", subtitle: "+5% this week", icon: "checkmark.circle.fill", color: .green)
        StatCardMB(title: "Streak", value: "12", subtitle: "Personal Best", icon: "flame.fill", color: .orange)
    }
    .padding()
    .background(Color.black)
}
