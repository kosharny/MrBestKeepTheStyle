import SwiftUI

struct ArticlesViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedArticle: MotivationModelMB?
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(themeManager.secondaryColor)
                    }
                    
                    Spacer()
                    
                    Text("Motivation")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .opacity(0)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.motivationalBlocks) { article in
                            ArticleCardMB(article: article)
                                .onTapGesture {
                                    selectedArticle = article
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedArticle) { article in
            ArticleDetailViewMB(article: article)
                .environmentObject(themeManager)
        }
    }
}

struct ArticleCardMB: View {
    let article: MotivationModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundColor(themeManager.secondaryColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(article.subtitle)
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            Text(article.content)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

struct ArticleDetailViewMB: View {
    let article: MotivationModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GlowBackgroundMB()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Close button
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
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
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.subtitle)
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryColor)
                        
                        Text(article.title)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    // Content
                    Text(article.content)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(6)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(15)
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ArticlesViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
}
