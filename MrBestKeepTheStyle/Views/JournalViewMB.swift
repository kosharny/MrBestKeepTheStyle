import SwiftUI

struct JournalViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @State private var showingAddEntry = false
    @State private var showingMotivationHub = false
    @State private var newEntryText = ""
    @State private var newEntryMood = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                GlowBackgroundMB()
                
                VStack(spacing: 0) {
                    HeaderMB(title: "Journal", subtitle: "Reflect on your journey")
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Motivation Hub Card
                            Button(action: { showingMotivationHub = true }) {
                                VStack(alignment: .leading, spacing: 12) {
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
                                            
                                            Image(systemName: "brain.head.profile")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Motivation Hub")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            Text("Fuel for your journey")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(themeManager.secondaryColor)
                                    }
                                }
                                .padding()
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
                            
                            // Journal Entries
                            if viewModel.journalEntries.isEmpty {
                                VStack(spacing: 15) {
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 60))
                                        .foregroundColor(themeManager.primaryColor.opacity(0.5))
                                    
                                    Text("No entries yet")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Start documenting your journey")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 60)
                            } else {
                                ForEach(viewModel.journalEntries.sorted(by: { $0.date > $1.date })) { entry in
                                    JournalEntryRow(entry: entry)
                                        .padding(.horizontal)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    viewModel.deleteJournalEntry(entry)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top) // Added padding to the top of the VStack inside ScrollView
                        .padding(.bottom, 100) // Keep this for overall bottom padding
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                
                // Hint Card and Add Button at bottom
                VStack {
                    Spacer()
                    HStack(spacing: 12) {
                        // Compact Hint Card
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                
                                Text("Share your journey")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            
                            Text("Document your progress and reflections")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(themeManager.primaryColor.opacity(0.3), lineWidth: 1)
                        )
                        
                        Spacer()
                        
                        // Add Entry Button
                        Button(action: { showingAddEntry = true }) {
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(themeManager.secondaryColor)
                                .clipShape(Circle())
                                .shadow(color: themeManager.secondaryColor.opacity(0.6), radius: 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Above TabBar
                }
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showingAddEntry) {
                AddJournalEntrySheet(isPresented: $showingAddEntry, text: $newEntryText, mood: $newEntryMood)
                    .environmentObject(viewModel)
                    .environmentObject(themeManager)
            }
            .sheet(isPresented: $showingMotivationHub) {
                MotivationViewMB()
                    .environmentObject(viewModel)
                    .environmentObject(themeManager)
            }
            .navigationBarHidden(true)
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntryMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Timeline Line
            VStack {
                Circle()
                    .fill(themeManager.primaryColor)
                    .frame(width: 10, height: 10)
                Rectangle()
                    .fill(themeManager.primaryColor.opacity(0.3))
                    .frame(width: 2)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(entry.text)
                    .font(.body)
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(0..<entry.moodScore, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(themeManager.secondaryColor)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct AddJournalEntrySheet: View {
    @Binding var isPresented: Bool
    @Binding var text: String
    @Binding var mood: Int
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("New Entry")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .foregroundColor(.white)
                
                HStack {
                    Text("Mood:")
                        .foregroundColor(.gray)
                    Slider(value: Binding(get: { Double(mood) }, set: { mood = Int($0) }), in: 1...5, step: 1)
                        .accentColor(themeManager.secondaryColor)
                }
                .padding()
                
                CustomButtonMB(title: "Save Entry", icon: "checkmark") {
                    let entry = JournalEntryMB(date: Date(), text: text, moodScore: mood)
                    viewModel.addJournalEntry(entry)
                    text = ""
                    mood = 5
                    isPresented = false
                }
                
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.gray)
            }
            .padding()
        }
    }
}


#Preview {
    JournalViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
        .background(Color.black)
}
