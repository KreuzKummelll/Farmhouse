//
//  DataModel.swift
//  Farmhouse
//
//  Created by Andrew McLane on 07.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Combine
import FarmhouseCore


final class DataModel {
    private let persistence: Persistence = Persistence()
    
    @Published var farmers: [Farmer] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func load() {
        persistence.load()
            .assign(to: \.farmers, on: self)
            .store(in: &cancellables)
    }
    
    func save() {
        persistence.save(farmers: farmers)
    }
    
    func loadDefault(synchronous: Bool = false) {
        persistence.loadDefault(synchronous: synchronous)
            .assign(to: \.farmers, on: self)
            .store(in: &cancellables)
    }
    func pushNewFarmer() {
        let new = Farmer()
        new.name = "New Farmer"
        farmers.insert(new, at: 0)
    }
    func removeFarmer(farmer: Farmer) {
        farmers.removeAll { $0.id == farmer.id}
    }
}

extension DataModel: ObservableObject {}

#if DEBUG
extension DataModel {
    static var sample: DataModel {
        let model = DataModel()
        model.farmers = [Farmer()]
        model.loadDefault(synchronous: true)
        return model
    }
}
#endif

