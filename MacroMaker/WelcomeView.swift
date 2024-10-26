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
    
    /* Whenever these vars are changed, the updated value can be accessed everywhere, regardless of set values in those files */
    
    @AppStorage("height") private var height: Double = 170 // in cm
    @AppStorage("weight") private var weight: Double = 70 // in kg
    @AppStorage("age") private var age: Int = 25
    @AppStorage("gender") private var gender: String = "Male"
    @AppStorage("activityLevel") private var activityLevel: String = "Sedentary"
    @AppStorage("recommendedCalories") private var recommendedCalories: Double = 0
    @AppStorage("recommendedProtein") private var recommendedProtein: Double = 0
    @AppStorage("recommendedCarbs") private var recommendedCarbs: Double = 0
    @AppStorage("recommendedFats") private var recommendedFats: Double = 0
    
    let genders = ["Male", "Female"]
    let activityLevels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active", "Super Active"]
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
                        Text("Height (cm):")
                        Spacer()
                        TextField("Height", value: $height, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Weight (kg):")
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
        recommendedProtein = weight * 1.8
        recommendedFats = weight * 0.8
        let proteinCalories = recommendedProtein * 4
        let fatCalories = recommendedFats * 9
        let carbCalories = tdee - proteinCalories - fatCalories
        recommendedCarbs = carbCalories / 4
    }
}