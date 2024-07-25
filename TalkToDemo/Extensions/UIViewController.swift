//
//  UIViewController.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import UIKit

extension UIViewController {
    func setLargeTitle(enabled: Bool) {
        if enabled {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        } else {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        self.navigationController?.navigationBar.sizeToFit()
    }
}
