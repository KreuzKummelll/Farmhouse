//
//  FarmerListInteractor.swift
//  Farmhouse
//
//  Created by Andrew McLane on 07.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Foundation
import FarmhouseCore

class FarmerListInteractor {
    let model: DataModel
    init(model: DataModel) {
        self.model = model
    }
    
    func addNewFarmer() {
        model.pushNewFarmer()
    }
    func deleteFarmer(_ index: IndexSet) {
        model.farms.remove(atOffsets: index)
    }
}
