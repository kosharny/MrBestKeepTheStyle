import SwiftUI

struct JournalViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    @State private var showingAddEntry = false
    @State private var newEntryText = ""
    @State private var newEntryMood = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                GlowBackgroundMB()
                
                VStack(spacing: 0) {
                    HeaderMB(title: "Journal", subtitle: "Reflect on your journey")
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            if viewModel.journalEntries.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 60))
                                        .foregroundColor(themeManager.secondaryColor.opacity(0.5))
                                    Text("No entries yet.\nStart writing your legacy.")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 50)
                            } else {
                                ForEach(viewModel.journalEntries) { entry in
                                    JournalEntryRow(entry: entry)
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                }
                
                // Floating Action Button for adding entry
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddEntry = true }) {
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(themeManager.secondaryColor)
                                .clipShape(Circle())
                                .shadow(color: themeManager.secondaryColor.opacity(0.6), radius: 10)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 100) // Above TabBar
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddJournalEntrySheet(isPresented: $showingAddEntry, text: $newEntryText, mood: $newEntryMood)
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
