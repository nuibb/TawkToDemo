//
//  AppRouting.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import UIKit

protocol AppNavigator {
    func hideNavigationTitle()
    func navigate(_ viewController: UIViewController)
    func present(_ viewController: UIViewController)
    func showFeedback(_ message: String)
}

extension AppNavigator {

    func navigate(_ viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(_ viewController: UIViewController) {
        UIApplication.topViewController()?.present(viewController, animated: true)
    }
    
    func showFeedback(_ message: String) {
        let controller = HostingController(
            rootView: FeedbackView(message: message)
        )
        controller.view.backgroundColor = UIColor.primaryColor?.withAlphaComponent(0.8)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller)
    }

    func hideNavigationTitle() {
        UIApplication.topViewController()?.navigationController?.navigationBar.topItem?.title = ""
    }
}

