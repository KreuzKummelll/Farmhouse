//
//  DataModel.swift
//  Farmhouse
//
//  Created by Andrew McLane on 07.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Combine


final class DataModel {
    private let persistence: Persistence = Persistence()
    
    @Published var farms: [PublicFarm] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func load() {
        persistence.load()
            .assign(to: \.farms, on: self)
            .store(in: &cancellables)
    }
    
    func save() {
//        persistence.save(farms: farms)
    }
    
    func loadDefault(synchronous: Bool = false) {
//        persistence.loadDefault(synchronous: synchronous)
//            .assign(to: \.farms, on: self)
//            .store(in: &cancellables)
    }
    func pushNewFarmer() {
        let new = PublicFarm()
        new.name = "New Farmer"
        farms.insert(new, at: 0)
    }
    func removeFarm(farm: PublicFarm) {
        farms.removeAll { $0.id == farm.id}
    }
    
    func pullFarms() {
        WebAPI.getFarms { result in
            switch result {
            case .success(let profile): print(profile)
            case .failure(let error): print("Error parsing Farms: \(error.localizedDescription)")
            }
        }
        
    }

}

extension DataModel: ObservableObject {}

#if DEBUG
extension DataModel {
    static var sample: DataModel {
        let model = DataModel()
        model.farms = [PublicFarm()]
        model.loadDefault(synchronous: true)
        return model
    }
}
#endif

