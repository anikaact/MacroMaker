import SwiftUI

struct AddMealView: View {
    
    @Binding var openAddMeal: Bool
    @Binding var mealDataString: String
    
    @State private var selectedMealType: String = "Breakfast"
    @State private var mealTitle: String = ""
    @State private var date: String = ""
    @State private var calories: String = ""
    @State private var fat: String = ""
    @State private var carbs: String = ""
    @State private var protein: String = ""

    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(mealTypes, id: \.self) { mealType in
                            Text(mealType).tag(mealType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("Meal Title", text: $mealTitle)
                        .autocapitalization(.words)
                }
                
                Section(header: Text("Nutritional Information")) {
                    TextField("Calories", text: $calories)
                        .keyboardType(.numberPad)
                    TextField("Fat (g)", text: $fat)
                        .keyboardType(.numberPad)
                    TextField("Carbs (g)", text: $carbs)
                        .keyboardType(.numberPad)
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    // confirm meal
                    Button(action: {
                        
                        date = formatDate(Date())
                        
                        mealDataString = mealDataString + "\n" + selectedMealType + "," + mealTitle + "," + date + "," + calories + "," + fat + "," + carbs + "," + protein
                        
                        selectedMealType = "Breakfast"
                        mealTitle = ""
                        date = ""
                        calories = ""
                        fat = ""
                        carbs = ""
                        protein = ""
                        
                        openAddMeal = false
                        
                    }) {
                        Text("Add Meal")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        selectedMealType = "Breakfast"
                        mealTitle = ""
                        fat = ""
                        carbs = ""
                        protein = ""
                        
                        openAddMeal = false
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}
