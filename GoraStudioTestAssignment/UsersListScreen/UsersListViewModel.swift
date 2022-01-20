//
//  UsersListViewModel.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

protocol UsersListViewModelProtocol: AnyObject {
    /// Used to notify ViewController to reload data of tableView
    var usersListLoaded: (() -> Void)? { get set }

    /// Used to show alert with error.
    var errorHandler: ((ErrorDomain) -> Void)? { get set }

    /// Asking data service to load users list.
    func loadUsersList()
    /// Just simple factory method to produce viewModel for next screen
    /// - Returns: ViewModel for AlbumsListViewModel
    func prepareViewModelForAlbumsScreen(atIndexPath indexPath: IndexPath) -> AlbumsListViewModelProtocol
}

final class UsersListViewModel: NSObject, UsersListViewModelProtocol {

    var users: [User] = []
    var usersListLoaded: (() -> Void)?
    var errorHandler: ((ErrorDomain) -> Void)?

    private let service: DataProvider = ImageFetchingService.shared

    func loadUsersList() {
        LockingView.lock()
        service.getListOfUsers { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorHandler?(error)
                LockingView.unlock()
            case .success(let users):
                self?.users = users
                self?.usersListLoaded?()
                LockingView.unlock()
            }
        }
    }

    func prepareViewModelForAlbumsScreen(atIndexPath indexPath: IndexPath) -> AlbumsListViewModelProtocol {
        let viewModel: AlbumsListViewModelProtocol = AlbumsListViewModel(
            albumsOfUserWithUSerID: users[indexPath.row].id
        )
        return viewModel
    }
}

// MARK: - TabelViewDelegate methods
extension UsersListViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommonCell.identifier,
            for: indexPath
        ) as? CommonCell else {
            return UITableViewCell()
        }
        cell.configure(with: users[indexPath.row].name)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}
