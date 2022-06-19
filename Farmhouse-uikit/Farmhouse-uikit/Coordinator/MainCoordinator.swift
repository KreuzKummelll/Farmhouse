//
//  MainCoordinator.swift
//  Farmhouse-uikit
//
//  Created by Andrew McLane on 6/19/22.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = UserSelectionViewController.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
}
