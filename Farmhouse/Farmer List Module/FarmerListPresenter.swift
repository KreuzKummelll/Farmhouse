//
//  FarmerListPresenter.swift
//  Farmhouse
//
//  Created by Andrew McLane on 07.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI
import Combine
import FarmhouseCore

class FarmerListPresenter: ObservableObject {
    private let interactor: FarmerListInteractor
    @Published var farmers: [Farmer] = []
    private var cancellables = Set<AnyCancellable>()
    private let router = FarmerListRouter()
    
    init(interactor: FarmerListInteractor) {
        self.interactor = interactor
        interactor.model.$farmers
            .assign(to: \.farmers, on: self)
            .store(in: &cancellables)
    }
    
    func makeAddNewButton() -> some View {
        Button(action: addNewFarmer) {
            Image(systemName: "plus")
        }
    }
    
    func addNewFarmer() {
        interactor.addNewFarmer()
    }
    
    func deleteFarmer(_ index: IndexSet) {
        interactor.deleteFarmer(index)
    }
    func linkBuilder<Content: View>(for farmer: Farmer, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeDetailView(for: farmer, model: interactor.model)) {
            content()
        }
    }
}
