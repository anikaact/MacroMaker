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
        Button(action: {
            isFirstTimeOpening = true
        }) {
            Text("Go back to setup")
        }
    }
}
