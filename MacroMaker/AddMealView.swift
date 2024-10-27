import SwiftUI

struct AddMealView: View {
    @State private var selectedMealType: MealType = .breakfast
    @State private var mealTitle: String = ""
    @State private var fat: String = ""
    @State private var carbs: String = ""
    @State private var protein: String = ""

    enum MealType: String, CaseIterable, Identifiable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        
        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(MealType.allCases) { mealType in
                            Text(mealType.rawValue).tag(mealType)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    TextField("Meal Title", text: $mealTitle)
                        .autocapitalization(.words)
                }
                
                Section(header: Text("Nutritional Information")) {
                    TextField("Fat (g)", text: $fat)
                        .keyboardType(.decimalPad)
                    TextField("Carbs (g)", text: $carbs)
                        .keyboardType(.decimalPad)
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button(action: addMeal) {
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
        }
    }
    
    private func addMeal() {
        print("Meal Added:")
        print("Type: \(selectedMealType.rawValue), Title: \(mealTitle), Fat: \(fat), Carbs: \(carbs), Protein: \(protein)")
        

        selectedMealType = .breakfast
        mealTitle = ""
        fat = ""
        carbs = ""
        protein = ""
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView()
    }
}
