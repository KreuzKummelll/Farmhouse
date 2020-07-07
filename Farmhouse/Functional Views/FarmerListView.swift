//
//  FarmerListView.swift
//  Farmhouse
//
//  Created by Andrew McLane on 06.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI
import FarmhouseCore

struct FarmerListView: View {
    @ObservedObject var presenter: FarmerListPresenter
    var body: some View {
        List {
            ForEach(presenter.farmers, id: \.id) { item in
                self.presenter.linkBuilder(for: item) {
                    FarmerListCell(farmer: item)
                        .frame(height: 240
                    )
                }
            }.onDelete(perform: presenter.deleteFarmer)
        }
        .navigationBarTitle("Farmers", displayMode: .inline)
        .navigationBarItems(trailing: presenter.makeAddNewButton())
    }
}

struct FarmerListView_Previews: PreviewProvider {
    @ObservedObject var presenter: FarmerListPresenter
    
    static var previews: some View {
        let model = DataModel.sample
        let interactor = FarmerListInteractor(model: model)
        let presenter = FarmerListPresenter(interactor: interactor)
        return NavigationView {
            FarmerListView(presenter: presenter)
        }
    }
}
