import SwiftUI

struct AddHabitViewMB: View {
    @EnvironmentObject var viewModel: ViewModelMB
    @EnvironmentObject var themeManager: ThemeManagerMB
    
    @State private var title = ""
    @State private var description = ""
    @State private var type: HabitTypeMB = .build
    @State private var targetDays = 30.0
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                GlowBackgroundMB()
                
                VStack(spacing: 0) {
                    HeaderMB(title: "New Habit", subtitle: "Design your future")
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            // Type Selection - Custom Buttons
                            HStack(spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        type = .build
                                    }
                                }) {
                                    Text("Build Habit")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(type == .build ? .white : .gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(type == .build ? themeManager.secondaryColor : Color.clear)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        type = .quit
                                    }
                                }) {
                                    Text("Quit Habit")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(type == .quit ? .white : .gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(type == .quit ? Color.red : Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Input Fields
                            VStack(alignment: .leading, spacing: 15) {
                                InputField(title: "Habit Name", placeholder: "e.g., Morning Run", text: $title)
                                DescriptionField(title: "Description", placeholder: "Why are you doing this? Describe your motivation and goals...", text: $description)
                            }
                            .padding(.horizontal)
                            
                            // Picker for Target Days
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Target Duration")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Picker("Days", selection: $targetDays) {
                                    ForEach([7, 14, 21, 30, 45, 60, 90, 120, 180, 365], id: \.self) { days in
                                        Text("\(days) Days").tag(Double(days))
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 120)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            CustomButtonMB(
                                title: "Commit to Excellence",
                                icon: "flag.fill",
                                action: {
                                    if title.isEmpty {
                                        showAlert = true
                                    } else {
                                        let newHabit = HabitModelMB(
                                            title: title,
                                            description: description,
                                            type: type,
                                            targetDays: Int(targetDays),
                                            startDate: Date(),
                                            completedDays: [],
                                            notes: ""
                                        )
                                        viewModel.addHabit(newHabit)
                                        // Reset fields
                                        title = ""
                                        description = ""
                                        targetDays = 30
                                        type = .build
                                    }
                                },
                                colorOverride: type == .quit ? .red : .green
                            )
                        }
                        .padding(.top, 20)
                        
                        Space(100)
                    }
                }
            }
            .customAlert(isPresented: $showAlert, alert: CustomAlertMB(
                title: "Missing Information",
                message: "Please enter a habit name to continue.",
                primaryButton: .init(title: "OK", isPrimary: true) { },
                secondaryButton: nil
            )).navigationBarHidden(true)
        }
    }
    
    // Helper to create spacing
    func Space(_ height: CGFloat) -> some View {
        Spacer().frame(height: height)
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}

struct DescriptionField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .frame(height: 100)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    AddHabitViewMB()
        .environmentObject(ViewModelMB())
        .environmentObject(ThemeManagerMB())
        .background(Color.black)
}
