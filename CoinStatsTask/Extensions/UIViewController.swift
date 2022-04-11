//
//  UIViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 11.04.22.
//

import UIKit

extension UIViewController {
    static func getInstance(from storyboard: UIStoryboard) -> Self {
        guard let viewController = storyboard
            .instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
        else { fatalError("View Controller initialization issue") }

        return viewController
    }
}
