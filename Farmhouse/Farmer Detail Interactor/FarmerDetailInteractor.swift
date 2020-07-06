//
//  FarmerDetailInteractor.swift
//  Farmhouse
//
//  Created by Andrew McLane on 15.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Combine
import MapKit

class FarmerDetailInteractor {
    private let farmer: Farmer
    private let model: DataModel
    let mapInfoProvider: MapDataProvider
    
    var farmerName: String { farmer.name }
    var farmerNamePublisher: Published<String>.Publisher { farmer.$name }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var totalDistance: Measurement<UnitLength> = Measurement(value: 0, unit: .meters)
    @Published var waypoints: [Waypoint] = []
    @Published var directions: [MKRoute] = []
    
    
    init(farmer: Farmer, model: DataModel, mapInfoProvider: MapDataProvider) {
        self.farmer = farmer
        self.mapInfoProvider = mapInfoProvider
        self.model = model
    }
    
    // Methods
    func setFarmerName(_ name: String) {
        farmer.name = name
    }
    func save() {
        model.save()
    }
}
