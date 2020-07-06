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
    var body: some View {
        NavigationView {
            FarmerListView(presenter:
                FarmerListPresenter(interactor: FarmerListInteractor(model: model))
            )
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
