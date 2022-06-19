//
//  ContentView.swift
//  Farmhouse
//
//  Created by Andrew McLane on 06.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: DataModel
    
    @State private var tabViewSelectionIndex = 1
    
    var body: some View {
        TabView(selection: $tabViewSelectionIndex) {
            
        HomeView()
            .tabItem {
                Image(systemName: "house")
            }.tag(1)
        
        Text("Search")
            .tabItem {
                Image(systemName: "magnifyingglass")
            }.tag(2)
        }
        
        .onAppear{
            model.pullFarms()
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel.sample
        return ContentView()
        .environmentObject(model)
    }
}
