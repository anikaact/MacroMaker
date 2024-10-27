//
//  WelcomeView.swift
//  MacroMaker
//
//  Created by Chris Souk on 10/26/24.
//

import SwiftUI
import CoreData

struct WelcomeView: View {
    
    @Binding var isFirstTimeOpening: Bool
    
    @State private var height: Double = 65 // in cm
    @State private var weight: Double = 130 // in kg
    @State private var age: Int = 25
    @State private var gender: String = "Male"
    @State private var weightGoal: String = "Maintain"
    @State private var activityLevel: String = "Sedentary"
    
    @Binding var recommendedCalories: Double
    @Binding var recommendedProtein: Double
    @Binding var recommendedCarbs: Double
    @Binding var recommendedFats: Double
    
    let genders = ["Male", "Female"]
    let activityLevels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active", "Super Active"]
    let weightGoals = ["Loss", "Maintain", "Gain"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Macro Calculator")
                .font(.largeTitle)
                .bold()
            
            Form {
                Section(header: Text("Personal Information")) {
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) { Text($0) }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Height (in):")
                        Spacer()
                        TextField("Height", value: $height, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Weight (lbs):")
                        Spacer()
                        TextField("Weight", value: $weight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Age:")
                        Spacer()
                        TextField("Age", value: $age, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                }
                
                Section(header: Text("Weight Goal: ")) {
                    Picker("Weight Goal", selection: $weightGoal) {
                        ForEach(activityLevels, id: \.self) { Text($0) }
                    }
                }
                
                Section(header: Text("Activity Level")) {
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(activityLevels, id: \.self) { Text($0) }
                    }
                }
                
                Button(action: calculateMacros) {
                    Text("Calculate Macros")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if recommendedCalories > 0 {
                    Section(header: Text("Recommended Macros")) {
                        Text("Calories: \(Int(recommendedCalories)) kcal")
                        Text("Protein: \(Int(recommendedProtein)) g")
                        Text("Carbs: \(Int(recommendedCarbs)) g")
                        Text("Fats: \(Int(recommendedFats)) g")
                        Button(action: {
                            isFirstTimeOpening = false
                        }) {
                            Text("Continue!")
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
            .padding()
        }
    }
    
    func calculateMacros() {
        let bmr: Double
        
        // Calculate BMR using the Mifflin-St Jeor Equation
        if gender == "Male" {
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
        
        // Adjust BMR based on activity level
        let multiplier: Double
        switch activityLevel {
        case "Sedentary": multiplier = 1.2
        case "Lightly Active": multiplier = 1.375
        case "Moderately Active": multiplier = 1.55
        case "Very Active": multiplier = 1.725
        case "Super Active": multiplier = 1.9
        default: multiplier = 1.2
        }
        
        let tdee = bmr * multiplier
        recommendedCalories = tdee
        
        // Calculate macros based on TDEE
        switch weightGoal {
        case "Loss":
            recommendedCalories = recommendedCalories * 0.85
            recommendedCarbs = recommendedCalories * 0.4
            recommendedProtein = recommendedCalories * 0.4
            recommendedFats = recommendedCalories * 0.2
        case "Maintain":
            recommendedCarbs = recommendedCalories * 0.4
            recommendedProtein = recommendedCalories * 0.3
            recommendedFats = recommendedCalories * 0.3
        case "Gain":
            recommendedCalories = recommendedCalories + 500
            recommendedCarbs = recommendedCalories * 0.4
            recommendedProtein = recommendedCalories * 0.3
            recommendedFats = recommendedCalories * 0.3
        default:
            recommendedCalories = recommendedCalories
        }
    }
}
