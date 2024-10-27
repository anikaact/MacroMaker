//
//  SettingsView.swift
//  MacroMaker
//
//  Created by Chris Souk on 10/26/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isFirstTimeOpening: Bool
    
    var body: some View {
        NavigationView {
            Button(action: {
                isFirstTimeOpening = true
            }) {
                Text("Go back to setup")
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                }) {
                    Text("Back")
                }
            }
        }
        
    }
}
