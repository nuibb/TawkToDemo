//
//  HostingController.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import SwiftUI

class HostingController<Content>: UIHostingController<AnyView> where Content: View {
    var content: Content
    var navigationBarTitle: String?
    var enableLargeNavigationBarMode: Bool?
    
    init(
        rootView: Content,
        navigationBarTitle: String? = nil,
        enableLargeNavigationBarMode: Bool? = nil) {
            self.content = rootView
            super.init(rootView: AnyView(rootView))
            self.navigationBarTitle = navigationBarTitle
            self.enableLargeNavigationBarMode = enableLargeNavigationBarMode
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let enableLargeNavigationBarMode = self.enableLargeNavigationBarMode {
            setLargeTitle(enabled: enableLargeNavigationBarMode)
        }
        
        if let title = navigationBarTitle {
            self.navigationItem.title = title
            //self.navigationController?.navigationBar.topItem?.title = title
        }
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
