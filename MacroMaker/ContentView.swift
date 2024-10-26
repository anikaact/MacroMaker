//
//  ContentView.swift
//  MacroMaker
//
//  Created by a on 10/26/24.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @AppStorage("isFirstTimeOpening") var isFirstTimeOpening: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            if isFirstTimeOpening {
                WelcomeView(isFirstTimeOpening: $isFirstTimeOpening)
            } else {
                TabView {
                    SettingsView(isFirstTimeOpening: $isFirstTimeOpening)
                        .tabItem {
                            Label("", systemImage: "gearshape")
                        }
                    AddMealView()
                        .tabItem {
                            Label("", systemImage: "plus")
                        }
                }
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }

}
