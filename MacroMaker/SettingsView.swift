//
//  SettingsView.swift
//  MacroMaker
//
//  Created by Chris Souk on 10/26/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var openSettings: Bool
    @Binding var isFirstTimeOpening: Bool
    @Binding var mealDataString: String
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isFirstTimeOpening = true
                }) {
                    Text("Go back to setup")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    mealDataString = ""
                }) {
                    Text("Reset meal data")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        openSettings = false
                    }) {
                        Text("Back")
                    }
                }
            }
        }
        
    }
}
