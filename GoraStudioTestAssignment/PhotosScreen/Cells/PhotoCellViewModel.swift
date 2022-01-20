//
//  PhotoCellViewModel.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

protocol PhotoCellViewModelProtocol: AnyObject {
    init(withPhotoModel photo: Photo)

    /// Asks service to load list of corresponding models.
    func loadPhoto()

    /// Callback to notify ViewController to display asynchronously loaded image.
    var updateImageView: ((UIImage) -> Void)? { get set }
    /// Just a string to display in cell
    var photoDescription: String { get }

    /// Kind of image cache in viewModel to avoid work which is not required in some cases.
    var photoImage: UIImage? { get }
}

final class PhotoCellViewModel: NSObject, PhotoCellViewModelProtocol {
    private let photo: Photo
    private(set) var photoImage: UIImage?
    private let service: DataProvider = ImageFetchingService.shared
    private var expectedContentLength: Float = 0
    private var buffer: NSMutableData = NSMutableData()
    
    init(withPhotoModel photo: Photo) {
        self.photo = photo
    }
    
    var updateProgressBarWithFraction: ((Float) -> Void)?
    var updateImageView: ((UIImage) -> Void)?
    var photoDescription: String {
        photo.title
    }
    
    func loadPhoto() {
        guard photoImage == nil else {
            updateImageView?(photoImage!)
            return }
        service.loadPhoto(url: photo.url) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                DispatchQueue.global(qos: .utility).async {
                    if let image = UIImage(data: data) {
                        self?.photoImage = image
                        self?.updateImageView?(image)
                    }
                }
            }
        }
    }
}
