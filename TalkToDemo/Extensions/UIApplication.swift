//
//  UIApplication.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }

        return viewController
    }
}
