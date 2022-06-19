//
//  TripDetailView.swift
//  Farmhouse
//
//  Created by Andrew McLane on 15.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI

struct FarmerDetailView: View {
    @ObservedObject var presenter: FarmerDetailPresenter
    
    var body: some View {
        VStack {
            TextField("Farmer Name", text: presenter.setFarmerName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal])
            
        }
        .navigationBarTitle(Text(presenter.farmerName), displayMode: .inline)
        .navigationBarItems(trailing: Button("Save", action: presenter.save))
    }
    
    
}


#if DEBUG
struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel.sample
        let farmer = model.farms[1]
//        let mapProvider = RealMapDataProvider()
        let presenter = FarmDetailPresenter(interactor:
            FarmDetailInteractor(
                farmer: farmer,
                model: model,
                mapInfoProvider: mapProvider))
        return NavigationView {
            FarmerDetailView(presenter: presenter)
        }
    }
}
#endif
