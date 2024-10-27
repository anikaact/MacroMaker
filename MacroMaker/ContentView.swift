import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("isFirstTimeOpening") var isFirstTimeOpening: Bool = true
    @AppStorage("mealDataString") var mealDataString: String = ""
    
    @State private var mealData: [String] = []
    
    @State private var showDatePicker = false
    
    @State private var openSettings: Bool = false
    @State private var openAddMeal: Bool = false
    
    @State private var selectedDate: Date = Date()
    
    @AppStorage("recommendedCalories") var recommendedCalories: Double = 0.0
    @AppStorage("recommendedProtein") var recommendedProtein: Double = 0.0
    @AppStorage("recommendedCarbs") var recommendedCarbs: Double = 0.0
    @AppStorage("recommendedFats") var recommendedFats: Double = 0.0
    
    @State public static var consumedCalories: Double = 0.0
    @State public static var consumedProtein: Double = 0.0
    @State public static var consumedCarbs: Double = 0.0
    @State public static var consumedFats: Double = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            if isFirstTimeOpening {
                WelcomeView(isFirstTimeOpening: $isFirstTimeOpening, recommendedCalories: $recommendedCalories, recommendedProtein: $recommendedProtein, recommendedCarbs: $recommendedCarbs, recommendedFats: $recommendedFats)
            } else {
                if openSettings {
                    SettingsView(openSettings: $openSettings, isFirstTimeOpening: $isFirstTimeOpening, mealDataString: $mealDataString)
                } else if openAddMeal {
                    AddMealView(openAddMeal: $openAddMeal, mealDataString: $mealDataString)
                } else {
                    NavigationView {
                        VStack {
                            // Displaying recommended values as bars
                            VStack(spacing: 10) {
                                BarGraph(value: ContentView.consumedCalories, total: recommendedCalories, label: "Calories")
                                BarGraph(value: ContentView.consumedProtein, total: recommendedProtein, label: "Protein")
                                BarGraph(value: ContentView.consumedCarbs, total: recommendedCarbs, label: "Carbs")
                                BarGraph(value: ContentView.consumedFats, total: recommendedFats, label: "Fats")
                            }
                            .padding()

                            // Displaying meal data
                            VStack(spacing: 10) {
                                ForEach(parseMealDataString(mealDataString: mealDataString)!, id: \.title) { mealCard in
                                    mealCard
                                }
                            }
                        }
                        .navigationTitle(formatDate(selectedDate)) // Center title with today's date
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            // Top Navigation Bar Items
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                                }) {
                                    Image(systemName: "arrow.backward")
                                }
                            }
                            
                            ToolbarItem(placement: .principal) {
                                Button(action: {
                                    showDatePicker = true // Show the date picker when tapped
                                }) {
                                    Text(formatDate(selectedDate))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                .sheet(isPresented: $showDatePicker) {
                                    DatePickerView(selectedDate: $selectedDate)
                                }
                            }

                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                                }) {
                                    Image(systemName: "arrow.forward")
                                }
                            }
                            
                            // Bottom Toolbar Items
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button(action: {
                                    openSettings = true
                                }) {
                                    Image(systemName: "gear")
                                }

                                Button(action: {
                                    openAddMeal = true
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// Separate view for the DatePicker
struct DatePickerView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle()) // Graphical style for visual selection
                .padding()
            
            Spacer()
            
            Button(action: {
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            }) {
                Text("Select Date")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium // Adjust to .short, .medium, .long, etc., as needed
    formatter.timeStyle = .none // Set this to .short, .medium, or .long if time is needed
    return formatter.string(from: date)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BarGraph: View {
    var value: Double
    var total: Double
    var label: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            
            ZStack(alignment: .leading) {
                // Background bar with 100% width
                Rectangle()
                    .fill(Color.gray.opacity(0.3)) // Light gray background color
                    .frame(height: 20)
                    .cornerRadius(5)

                // Foreground bar that scales with value
                Rectangle()
                    .fill(Color.blue) // Progress bar color
                    .frame(width: CGFloat(value / total) * UIScreen.main.bounds.width * 0.75, height: 20) // Width based on value and 75% of screen width
                    .cornerRadius(5)
                    .animation(.easeInOut) // Smooth animation for bar update
            }
            .frame(width: UIScreen.main.bounds.width * 0.75) // Restrict the bar width to 75% of screen width
            
            HStack {
                Text("0") // Left value
                    .font(.subheadline)
                Spacer()
                Text("\(Int(total))") // Right value
                    .font(.subheadline)
            }
            .frame(width: UIScreen.main.bounds.width * 0.75) // Match width to the bar
        }
        .padding(.vertical, 5) // Vertical padding between bars
    }
}

struct MealDataCard: View {
    var mealType: String
    var title: String
    var date: String
    var calories: String
    var fat: String
    var carbs: String
    var protein: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(mealType)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.title2)
                .foregroundColor(.primary)

            HStack {
                VStack(alignment: .leading) {
                    Text("Calories: \(calories)")
                    Text("Fat: \(fat) g")
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Carbs: \(carbs) g")
                    Text("Protein: \(protein) g")
                }
            }
            .font(.body)
            .foregroundColor(.primary)
            
            Divider()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

func parseMealDataString(mealDataString: String) -> [MealDataCard]? {
    let meals = mealDataString.split(separator: "\n")
    
    return meals.enumerated().compactMap { index, meal in
        let components = meal.split(separator: ",").map { String($0) }
        
        guard components.count == 7 else { return nil}
        
        ContentView.consumedCalories += Double(components[3]) ?? 0.0
        ContentView.consumedProtein += Double(components[6]) ?? 0.0
        ContentView.consumedCarbs += Double(components[5]) ?? 0.0
        ContentView.consumedFats += Double(components[4]) ?? 0.0
        
        return MealDataCard(
            mealType: components[0],
            title: components[1],
            date: components[2],
            calories: components[3],
            fat: components[4],
            carbs: components[5],
            protein: components[6]
        )
    }
}
