//
//  PhotosScreenViewController.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

final class PhotosScreenViewController: UIViewController {
    let viewModel: PhotosScreenViewModelProtocol!

    lazy var photosCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = viewModel as! PhotosScreenViewModel
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.toAutoLayout()
        return collectionView
    }()

    init(withViewModel viewModel: PhotosScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        title = "Photos"
        viewModel.photosListLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.photosCollection.reloadData()
            }
        }

        viewModel.errorHandler = { [weak self] error in
            self?.alert(error: error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupAutoLayout()
        viewModel.loadListOfPhotos()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupAutoLayout() {
        view.addSubview(photosCollection)
        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            photosCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            photosCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CollectionViewDelegate methods
extension PhotosScreenViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCell else {
            return
        }
        cell.loadPhoto()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // --Dunno how but this tricky dog-nail works as expected without any warnings.
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
