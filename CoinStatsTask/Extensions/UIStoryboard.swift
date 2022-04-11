//
//  UIStoryboard.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 11.04.22.
//

import UIKit

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main")

    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
}
