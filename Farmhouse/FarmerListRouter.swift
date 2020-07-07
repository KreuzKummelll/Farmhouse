//
//  FarmerListRouter.swift
//  Farmhouse
//
//  Created by Andrew McLane on 15.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI
import FarmhouseCore

class FarmerListRouter {
    func makeDetailView(for farmer: Farmer, model: DataModel) -> some View {
        let present = FarmerDetailPresenter(interactor: FarmerDetailInteractor(farmer: farmer, model: model, mapInfoProvider: RealMapDataProvider()))
        return FarmerDetailView(presenter: present)
    }
}
