//
//  FarmerDetailInteractor.swift
//  Farmhouse
//
//  Created by Andrew McLane on 15.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Combine
import MapKit
import FarmhouseCore

class FarmerDetailInteractor {
    private let farm: Farm
    private let model: DataModel
//    let mapInfoProvider: MapDataProvider
    
    var farmName: String { farm.name }
    var farmNamePublisher: Published<String>.Publisher { farm.$name }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var totalDistance: Measurement<UnitLength> = Measurement(value: 0, unit: .meters)
//    @Published var waypoints: [Waypsoint] = []
    @Published var directions: [MKRoute] = []
    
    
    init(farmer: Farm, model: DataModel, mapInfoProvider: MapDataProvider) {
        self.farm = farm
        self.mapInfoProvider = mapInfoProvider
        self.model = model
    }
    
    // Methods
    func setFarmerName(_ name: String) {
        farm.name = name
    }
    func save() {
        model.save()
    }
}
