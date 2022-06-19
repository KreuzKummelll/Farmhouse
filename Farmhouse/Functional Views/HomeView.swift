//
//  HomeView.swift
//  Farmhouse
//
//  Created by Andrew McLane on 12/13/20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: DataModel
    
    @State private var vGridLayout = [ GridItem(.flexible()), GridItem(.adaptive(minimum: 100, maximum: 200)) ]
    
    
    var body: some View {
        

        NavigationView {
            ScrollView {
                LazyVGrid(columns: vGridLayout) {
                    // 4
                    ForEach(model.farms, id: \.name) { value in
                        // 5
                        Rectangle()
                            .foregroundColor(Color.init(white: 0.95))
                            .frame(height: 50)
                            .overlay(
                                // 6
                                Text("\(value.name)").foregroundColor(.init(white: 0.19))
                            )
                    }
                }.padding(.all, 10)
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
