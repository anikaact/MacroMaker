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
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isFirstTimeOpening = true
                }) {
                    Text("Go back to setup")
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
