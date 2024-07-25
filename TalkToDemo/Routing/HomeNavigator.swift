//
//  HomeNavigator.swift
//  TalkToDemo
//
//  Created by Nurul Islam on 20/7/24.
//

import Foundation

protocol HomeNavigator: AppNavigator {
    func navigateToProfileView(_ user: User)
}

extension HomeNavigator {
    
    func navigateToProfileView(_ user: User) {
        let controller = HostingController(
            rootView: ProfileView(
                viewModel: ProfileViewModel(
                    user: user,
                    remoteDataProvider: ApiServiceProvider.shared,
                    localDataProvider: StorageDataProvider(
                        context: PersistentStorage.shared.context
                    )
                )
            ),
            navigationBarTitle: Constants.profileNavTitle
        )
        self.navigate(controller)
    }
}
