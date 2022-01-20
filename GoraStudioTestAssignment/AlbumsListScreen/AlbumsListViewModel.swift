//
//  AlbumsListViewModel.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Foundation
import UIKit

protocol AlbumsListViewModelProtocol: AnyObject {
    /// Asking embeded service to load albums list
    func loadAlbumsList()

    /// Simple factory method to produce viewModel for next screen
    /// - Returns: ViewModel for PhotosScreenViewController
    func preparePhotosScreenViewModel(forAlbumAtIndexPath indexPath: IndexPath) -> PhotosScreenViewModelProtocol

    /// Initialization
    init(albumsOfUserWithUSerID id: Int)

    /// Callback to notify ViewController to reload data in tableView
    var usersLoaded: (() -> Void)? { get set }
    
    /// Callback to pass an error to ViewController to show it at alertController
    var errorOccurred: ((ErrorDomain) -> Void)? { get set }
}

final class AlbumsListViewModel: NSObject, AlbumsListViewModelProtocol {
    let service: DataProvider = ImageFetchingService.shared
    let userID: Int
    var albums:[Album] = []
    var usersLoaded: (() -> Void)?
    var errorOccurred: ((ErrorDomain) -> Void)?
    init(albumsOfUserWithUSerID id: Int) {
        userID = id
    }
    
    func loadAlbumsList() {
        LockingView.lock()
        service.getListOfAlbums(byUserId: userID) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.errorOccurred?(error)
                LockingView.unlock()
            case let .success(albums):
                self?.albums = albums
                self?.usersLoaded?()
                LockingView.unlock()
            }
        }
    }

    func preparePhotosScreenViewModel(forAlbumAtIndexPath indexPath: IndexPath) -> PhotosScreenViewModelProtocol {
        return PhotosScreenViewModel(albumID: albums[indexPath.row].id)
    }
}

extension AlbumsListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonCell.identifier, for: indexPath)
                as? CommonCell else { return UITableViewCell() }
        cell.configure(with: albums[indexPath.row].title)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}
