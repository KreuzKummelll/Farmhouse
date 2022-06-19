//
//  FarmerDetailPresenter.swift
//  Farmhouse
//
//  Created by Andrew McLane on 15.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Combine
import SwiftUI

// Separating the farmer name into properties like this allows one to synchronize the value without creating an infinite loop of updates. -- RW
class FarmerDetailPresenter: ObservableObject {
    private let interactor: FarmerDetailInteractor
    private var cancellables = Set<AnyCancellable>()
    @Published var farmName: String = "No name"
    
    let setFarmName: Binding<String>

    init(interactor: FarmerDetailInteractor) {
        self.interactor = interactor
        setFarmerName = Binding<String>(
            get: {interactor.farmName}, set: {interactor.setFarmerName($0) }
        )
        
        interactor.farmNamePublisher
            .assign(to: \.farmName, on: self)
            .store(in: &cancellables)
    }
    
    // METHODS
    func save() {
        interactor.save()
    }
    
}
