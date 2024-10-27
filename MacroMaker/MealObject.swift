//
//  MealObject.swift
//  MacroMaker
//
//  Created by Anika Thapar on 10/26/24.
//

import Foundation

class MealObject {
    var type: String
    var title: String
    var date: Date
    var fat: String
    var carbs: String
    var protein: String
    
    init(Type: String, Title: String, date: Date, fat: String, carbs: String, protein: String) {
        self.type = Type
        self.title = Title
        self.date = date
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
    }
}
