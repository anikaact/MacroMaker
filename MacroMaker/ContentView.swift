//
//  ContentView.swift
//  MacroMaker
//
//  Created by a on 10/26/24.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @AppStorage("isFirstTimeOpening") var isFirstTimeOpening: Bool = true
    @AppStorage("mealDataString") var mealDataString: String = ""
    
    @State private var mealDataStrings: [String] = []
    
    @State private var showDatePicker = false
    
    @State private var openSettings: Bool = false
    @State private var openAddMeal: Bool = false
    
    @State private var selectedDate: Date = Date()
    
    @AppStorage("recommendedCalories") var recommendedCalories: Double = 0.0
    @AppStorage("recommendedProtien") var recommendedProtein: Double = 0.0
    @AppStorage("recommendedCarbs") var recommendedCarbs: Double = 0.0
    @AppStorage("recommendedFats") var recommendedFats: Double = 0.0
    
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
                            Text(mealDataString)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .navigationTitle(formatDate(selectedDate)) // Center title with today's date
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            // Top Navigation Bar Items
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to:  selectedDate) ?? selectedDate
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
        .onAppear {
            mealDataStrings = mealDataString.split(separator: "\n") as? [String] ?? [""]
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
