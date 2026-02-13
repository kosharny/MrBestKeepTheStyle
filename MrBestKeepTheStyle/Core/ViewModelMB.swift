import SwiftUI
import Combine

class ViewModelMB: ObservableObject {
    @Published var habits: [HabitModelMB] = [] {
        didSet { saveHabits() }
    }
    @Published var journalEntries: [JournalEntryMB] = [] {
        didSet { saveJournal() }
    }
    @Published var showOnboarding: Bool = true
    
    // Core Managers
    let themeManager = ThemeManagerMB()
    
    // MARK: - Static Content (Motivation & Insights)
    // 20+ Motivational Insight Blocks
    let motivationalBlocks: [MotivationModelMB] = [
        MotivationModelMB(title: "Identity Shift", subtitle: "Becoming MrBest", content: "True change is identity-based. You don't just 'run', you ARE a runner. To keep the style, you must first believe you are the person who embodies it. Every action you take is a vote for the type of person you wish to become.", imageName: "motivation_identity"),
        MotivationModelMB(title: "The 1% Rule", subtitle: "Small Wins", content: "Improving by 1% every day results in being 37x better by the end of the year. Do not underestimate the power of small, consistent actions. They compound into massive results over time.", imageName: "stats_world_growth"),
        MotivationModelMB(title: "Dopamine Control", subtitle: "Rewire Your Brain", content: "Your brain seeks cheap dopamine. Social media, sugar, distractions. By resisting these urges, you reset your baseline. Hard work becomes easier because you aren't overstimulated. Master your dopamine, master your life.", imageName: "motivation_neon_brain"),
        MotivationModelMB(title: "Systems Over Goals", subtitle: "Process Focus", content: "Winners and losers have the same goals. The difference is the system. Build a system of daily habits that makes success inevitable. Forget the goal, focus on the rep.", imageName: "onboarding_growth_path"),
        MotivationModelMB(title: "Embrace Boredom", subtitle: "The Flow State", content: "Greatness is often boring. It's doing the same thing over and over again. The elite fall in love with the boredom of consistency. This is where the magic happens.", imageName: "onboarding_mrbest_pose"),
        MotivationModelMB(title: "Break The Pattern", subtitle: "Disrupt Loops", content: "Bad habits run on loops: Cue -> Craving -> Response -> Reward. To break a bad habit, you must disrupt this loop. Remove the cue or make the response difficult. Be conscious of your triggers.", imageName: "onboarding_break_pattern"),
        MotivationModelMB(title: "Environment Design", subtitle: "Architecture of Choice", content: "Motivation is overrated; environment implies design. If you want to drink more water, put bottles everywhere. If you want to read, put a book on your pillow. Design your space for success.", imageName: "onboarding_growth_path"),
        MotivationModelMB(title: "The 2 Minute Rule", subtitle: "Start Small", content: "When starting a new habit, it should take less than two minutes to do. 'Read before bed' becomes 'Read one page'. 'Run 3 miles' becomes 'Tie my running shoes'. Make it too easy to say no.", imageName: "mrbest_splash_energy"),
        MotivationModelMB(title: "Never Miss Twice", subtitle: "Consistency", content: "One mistake is an accident. Two is the start of a new habit. If you miss a day, get back on track immediately. The 'all or nothing' mentality is a trap. Just show up.", imageName: "onboarding_feedback_light"),
        MotivationModelMB(title: "Visual Cues", subtitle: "Reminders", content: "Make your habits obvious. Use a habit tracker like this one. Seeing your progress visualized is a powerful motivator. Don't break the chain.", imageName: "stats_world_growth"),
        // Adding more to reach 20+ requirement
        MotivationModelMB(title: "Temptation Bundling", subtitle: "Pairing", content: "Link an action you want to do with an action you need to do. Only listen to your favorite podcast while working out. Watch Netflix only while folding laundry.", imageName: "motivation_identity"),
        MotivationModelMB(title: "Social Contract", subtitle: "Accountability", content: "Tell someone your goals. The fear of social disapproval is a powerful motivator. Make a public commitment. Use 'MrBest' status as your standard.", imageName: "onboarding_mrbest_pose"),
        MotivationModelMB(title: "Energy Management", subtitle: "Not Just Time", content: "Manage your energy, not just your time. Do your hardest tasks when your energy is highest. Rest when you need to recharge. Burnout is the enemy of consistency.", imageName: "mrbest_splash_energy"),
        MotivationModelMB(title: "Reframing Failure", subtitle: "Data Points", content: "Failure is not the opposite of success; it's part of success. Every failed attempt provides data on what doesn't work. Iterate and improve.", imageName: "onboarding_break_pattern"),
        MotivationModelMB(title: "The Goldilocks Rule", subtitle: "Peak Motivation", content: "Humans experience peak motivation when working on tasks that are right on the edge of their current abilities. Not too hard. Not too easy. Just right.", imageName: "motivation_neon_brain"),
        MotivationModelMB(title: "Implementation Intention", subtitle: "Planning", content: "Use the formula: 'I will [BEHAVIOR] at [TIME] in [LOCATION]'. Clarity dissolves resistance. Give your habits a time and a place to live.", imageName: "onboarding_growth_path"),
        MotivationModelMB(title: "Identity Voting", subtitle: "Self-Belief", content: "Every time you choose the good habit, you cast a vote for the person you want to become. You don't need a unanimous vote to win an election, just a majority.", imageName: "motivation_identity"),
        MotivationModelMB(title: "Friction Reduction", subtitle: "Law of Least Effort", content: "Human nature follows the path of least resistance. Reduce the number of steps between you and your good habits. Increase the steps for bad habits.", imageName: "onboarding_mrbest_pose"),
        MotivationModelMB(title: "Delayed Gratification", subtitle: "Long Term", content: "Success usually requires suffering now for a reward later. Train your ability to wait. The marshmallow test is real. Choose the future over the present.", imageName: "mrbest_splash_energy"),
        MotivationModelMB(title: "Mastery Curve", subtitle: "The Plateau", content: "Progress is not linear. You will hit plateaus where it feels like nothing is happening. This is the 'Valley of Disappointment'. Keep going. The breakthrough is coming.", imageName: "stats_world_growth"),
        MotivationModelMB(title: "Default Mode Network", subtitle: "Mind Wandering", content: "When you aren't focused, your brain wanders to defaults. Train your default mode to be productive thinking, not anxiety. Meditation helps reset this.", imageName: "motivation_neon_brain"),
         MotivationModelMB(title: "Sleep & Recovery", subtitle: "Foundation", content: "You cannot build habits if you are exhausted. Sleep is when your brain consolidates learning and repairs itself. Prioritize 8 hours as a non-negotiable.", imageName: "onboarding_feedback_light"),
    ]
    
    let educationalBlocks: [InsightModelMB] = [
        InsightModelMB(title: "Neuroplasticity 101", content: "Your brain is plastic. It changes based on what you do. Repetition strengthens neural pathways. Neglect weakens them. You are sculpting your brain every day.", category: "Neuroscience"),
        InsightModelMB(title: "Basal Ganglia vs. Prefrontal Cortex", content: "Habits live in the basal ganglia (primitive brain). Rational decisions live in the prefrontal cortex (modern brain). Stress shuts down the prefrontal cortex, making you revert to habits.", category: "Neuroscience"),
        InsightModelMB(title: "Cortisol & Stress", content: "High cortisol levels impair cognitive function and willpower. Managing stress through breathwork or meditation is essential for habit maintenance.", category: "Physiology"),
        InsightModelMB(title: "The Power of Sleep", content: "Sleep deprivation acts like being drunk. It destroys impulse control. Prioritize sleep to maintain your 'MrBest' style discipline.", category: "Health"),
        InsightModelMB(title: "Hydration & Focus", content: "Even mild dehydration drops focus by 20%. Your brain is mostly water. Keep it fueled to maintain high performance.", category: "Health"),
        InsightModelMB(title: "Blue Light Effect", content: "Blue light from screens kills melatonin production. Poor sleep = poor willpower tomorrow. Use night shift mode.", category: "Health"),
        InsightModelMB(title: "Habit Stacking", content: "Anchor a new habit to an existing one. 'After I pour my coffee, I will meditate for one minute.' This uses the existing neural network of the old habit.", category: "Strategy"),
        InsightModelMB(title: "Visual Measurement", content: "We manage what we measure. Tracking provides objective truth in a subjective world. Don't lie to the data.", category: "Strategy"),
        InsightModelMB(title: "Community Influence", content: "You are the average of the 5 people you spend the most time with. Surround yourself with people who have the habits you want.", category: "Social"),
        InsightModelMB(title: "Keystone Habits", content: "Some habits ripple into others. Exercise is a keystone habit. It often leads to better eating, better sleep, and more productivity naturally.", category: "Strategy"),
        InsightModelMB(title: "Decision Fatigue", content: "You have a limited amount of decision-making energy each day. Automate trivial decisions (what to wear, what to eat) to save energy for what matters.", category: "Psychology"),
        InsightModelMB(title: "The Zeigarnik Effect", content: "Unfinished tasks occupy mental RAM. Finish what you start, or write it down to offload it from your brain.", category: "Psychology"),
        InsightModelMB(title: "Parkinson's Law", content: "Work expands to fill the time available for its completion. Set shorter deadlines to increase focus and efficiency.", category: "Productivity"),
        InsightModelMB(title: "Pareto Principle", content: "80% of results come from 20% of efforts. Identify the vital few habits that drive the majority of your life's quality.", category: "Productivity"),
        InsightModelMB(title: "Sunk Cost Fallacy", content: "Don't cling to a mistake just because you spent a lot of time making it. Pivot quickly. If a habit isn't serving you, drop it.", category: "Psychology"),
        InsightModelMB(title: "Confirmation Bias", content: "Your brain looks for evidence to support what you already believe. Believe you are capable, and your brain will find proof.", category: "Psychology"),
        InsightModelMB(title: "Growth Mindset", content: "Believe that your abilities can be developed. 'I can't do this YET'. This simple shift changes how you approach challenges.", category: "Mindset"),
        InsightModelMB(title: "Stoicism & Control", content: "Focus only on what you can control. You can control your actions and reactions. You cannot control the world. Accept it.", category: "Philosophy"),
        InsightModelMB(title: "Memento Mori", content: "Remember you will die. Time is finite. Don't waste it on bad habits or things that don't matter. Live with urgency.", category: "Philosophy"),
        InsightModelMB(title: "The Spotlight Effect", content: "People aren't watching you as much as you think. Stop worrying about judgment. focus on your own game.", category: "Psychology"),
         InsightModelMB(title: "Flow State Triggers", content: "High consequence, rich environment, deep embodiment. Learn to trigger flow for maximum productivity.", category: "Performance"),
    ]
    
    // MARK: - Initialization
    init() {
        if UserDefaults.standard.object(forKey: "showOnboardingMB") == nil {
            // First launch
            self.showOnboarding = true
            UserDefaults.standard.set(true, forKey: "showOnboardingMB")
        } else {
            self.showOnboarding = UserDefaults.standard.bool(forKey: "showOnboardingMB")
        }
        
        loadHabits()
        loadJournal()
    }
    
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(false, forKey: "showOnboardingMB")
    }
    
    // MARK: - Data Persistence
    func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "habitsMB")
        }
    }
    
    func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: "habitsMB"),
           let decoded = try? JSONDecoder().decode([HabitModelMB].self, from: data) {
            habits = decoded
        }
    }
    
    func saveJournal() {
        if let encoded = try? JSONEncoder().encode(journalEntries) {
            UserDefaults.standard.set(encoded, forKey: "journalMB")
        }
    }
    
    func loadJournal() {
        if let data = UserDefaults.standard.data(forKey: "journalMB"),
           let decoded = try? JSONDecoder().decode([JournalEntryMB].self, from: data) {
            journalEntries = decoded
        }
    }
    
    // MARK: - User Intentions
    func addHabit(_ habit: HabitModelMB) {
        habits.append(habit)
    }
    
    func deleteHabit(_ habit: HabitModelMB) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits.remove(at: index)
        }
    }
    
    func toggleHabitCompletion(habit: HabitModelMB, date: Date) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        
        let calendar = Calendar.current
        if let existingDateIndex = habits[index].completedDays.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) }) {
            habits[index].completedDays.remove(at: existingDateIndex)
        } else {
            habits[index].completedDays.append(date)
        }
    }
    
    // Simplified version for today
    func toggleHabitCompletion(_ habit: HabitModelMB) {
        toggleHabitCompletion(habit: habit, date: Date())
    }
    
    func resetHabit(_ habit: HabitModelMB) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].completedDays = []
    }
    
    func resetStreak(_ habit: HabitModelMB) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].completedDays.removeAll()
        // Or specific logic to break streak? "Relapse" usually implies resetting current progress but maybe keeping history? 
        // User said "reset the habit streak". Clearing completed days effectively resets it for this simple model.
        // A more complex model would track "streak breaks". For now, this suffices.
    }
    
    func addJournalEntry(_ entry: JournalEntryMB) {
        journalEntries.append(entry)
        // Sort by date new to old
        journalEntries.sort(by: { $0.date > $1.date })
    }
    
    // MARK: - Statistics Logic
    var totalHabitsCount: Int { habits.count }
    var goodHabitsCount: Int { habits.filter { $0.type == .build }.count }
    var badHabitsCount: Int { habits.filter { $0.type == .quit }.count }
    
    var improvementPercentage: Double {
        // Mock calculation based on completion
        let total = habits.reduce(0) { $0 + $1.progress }
        return totalHabitsCount > 0 ? (total / Double(totalHabitsCount)) * 100 : 0
    }
}
