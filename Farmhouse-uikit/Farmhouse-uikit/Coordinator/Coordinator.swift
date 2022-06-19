//
//  Coordinator.swift
//  Farmhouse-uikit
//
//  Created by Andrew McLane on 6/19/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
