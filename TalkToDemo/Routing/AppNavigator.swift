//
//  AppRouting.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import UIKit
//import GSMessages

protocol AppNavigator {
    func hideNavigationTitle()
    func navigate(_ viewController: UIViewController)
    func present(_ viewController: UIViewController)
    //func showFeedback(_ message: String, type: GSMessageType)
}

extension AppNavigator {

    func navigate(_ viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(_ viewController: UIViewController) {
        UIApplication.topViewController()?.present(viewController, animated: true)
    }
    
//    func showFeedback(_ message: String, type: GSMessageType) {
//        UIApplication.topViewController()?.showMessage(message, type: .error)
//    }

    func hideNavigationTitle() {
        UIApplication.topViewController()?.navigationController?.navigationBar.topItem?.title = ""
    }
}

