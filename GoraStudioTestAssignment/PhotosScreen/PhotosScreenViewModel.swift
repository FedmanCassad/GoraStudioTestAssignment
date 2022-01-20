//
//  PhotosScreenViewModel.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

protocol PhotosScreenViewModelProtocol: AnyObject {
    init(albumID id: Int)

    /// Simple factory method to produce viewModel for collectionView cell
    /// - Returns: viewModel for PhotoCell.
    func generateViewModelForCell(atIndexPath indexPath: IndexPath) -> PhotoCellViewModelProtocol

    /// Asks service to load list of photo models.
    func loadListOfPhotos()

    /// Callback to pass an error to show in alertController
    var errorHandler: ((ErrorDomain) -> Void)? { get set }

    /// Callback to notify PhotosScreenViewController to reload collectionView
    var photosListLoaded: (() -> Void)? { get set }
}

final class PhotosScreenViewModel: NSObject, PhotosScreenViewModelProtocol {
    private let albumID: Int
    private var photos: [Photo] = []
    private let service: DataProvider = ImageFetchingService.shared
    var errorHandler: ((ErrorDomain) -> Void)?
    var photosListLoaded: (() -> Void)?

    init(albumID id: Int) {
        self.albumID = id
    }


    func generateViewModelForCell(atIndexPath indexPath: IndexPath) -> PhotoCellViewModelProtocol {
    return PhotoCellViewModel(withPhotoModel: photos[indexPath.item])
    }

    func loadListOfPhotos() {
        LockingView.lock()
        service.getListOfPhotos(byAlbumId: albumID) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.errorHandler?(error)
                LockingView.unlock()
            case .success(let photos):
                self?.photos = photos
                self?.photosListLoaded?()
                LockingView.unlock()
            }
        }
    }
}

// MARK: - CollectionViewDataSource methods
extension PhotosScreenViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = generateViewModelForCell(atIndexPath: indexPath)
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        cell.maxWidth = UIScreen.main.bounds.width - 40
        cell.configure(withViewModel: viewModel)
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.clipsToBounds = true
        return cell
    }


}
