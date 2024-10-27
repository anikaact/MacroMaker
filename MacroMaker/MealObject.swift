//
//  MealObject.swift
//  MacroMaker
//
//  Created by Anika Thapar on 10/26/24.
//

import Foundation
import SwiftUI

class MealObject: Codable {
    var type: String
    var title: String
    var date: String
    var fat: String
    var carbs: String
    var protein: String
    
    init() {
        self.type = ""
        self.title = ""
        self.date = ""
        self.fat = ""
        self.carbs = ""
        self.protein = ""
    }
    
    init(type: String, title: String, date: String, fat: String, carbs: String, protein: String) {
        self.type = type
        self.title = title
        self.date = date
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
    }
}
