//
//  PhotoCell.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    /// Identifier to register cell
    static let identifier = String(describing: PhotoCell.self)

    // MARK: - Props
    var viewModel: PhotoCellViewModelProtocol!
    var maxWidth:  CGFloat?
    // MARK: - UI props
    lazy var mainView: UIView = {
        let view = UIView(frame: .zero)
        view.toAutoLayout()
        return view
    }()

    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds  = true
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = viewModel.photoDescription
        label.clipsToBounds = true
        label.toAutoLayout()
        return label
    }()

    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.toAutoLayout()
        return activityView
    }()

    // MARK: - Configuration method. Important!!!
    func configure(withViewModel viewModel: PhotoCellViewModelProtocol) {
        self.viewModel = viewModel
        guard photoView.image == nil else { return }
        setupAutoLayout()

        viewModel.updateImageView = { [weak self] image in
            DispatchQueue.main.async {
                self?.activityView.stopAnimating()
                self?.activityView.removeFromSuperview()
                self?.photoView.image = image
            }
        }
    }

    func loadPhoto() {
        viewModel.loadPhoto()
    }

    // MARK: - AutoLayout stuff
    private func setupAutoLayout() {
        contentView.addSubview(photoView)
        contentView.addSubview(descriptionLabel)
        photoView.addSubview(activityView)
        activityView.startAnimating()

        // --ContentView
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: maxWidth!),
        ])

        // --PhotoView
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo:  contentView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
            photoView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
        // --Description label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 2),
            descriptionLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // --Progress bar
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
        ])
    }
}
