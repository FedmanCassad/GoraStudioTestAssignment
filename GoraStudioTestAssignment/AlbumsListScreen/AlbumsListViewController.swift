//
//  AlbumsListViewController.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

final class AlbumsListsViewController: UIViewController {
    // MARK: - ViewModel
    let viewModel: AlbumsListViewModelProtocol

    // MARK: - UI Props
    lazy var albumsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = viewModel as! AlbumsListViewModel
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        tableView.register(CommonCell.self, forCellReuseIdentifier: CommonCell.identifier)
        tableView.toAutoLayout()
        return tableView
    }()

    // MARK: - Init
    init(withViewModel viewModel: AlbumsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.errorOccurred = { [weak self] error in
            self?.alert(error: error)
        }

        viewModel.usersLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.albumsTableView.reloadData()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        title = "Albums"
        setupAutoLayout()
        view.backgroundColor = .white
        viewModel.loadAlbumsList()
    }

    // MARK: - AutoLayout stuff
    private func setupAutoLayout() {
        view.addSubview(albumsTableView)
        NSLayoutConstraint.activate([
            albumsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            albumsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            albumsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableViewDelegate methods
extension AlbumsListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let viewModel = viewModel.preparePhotosScreenViewModel(forAlbumAtIndexPath: indexPath)
        let photosVC = PhotosScreenViewController(withViewModel: viewModel)
        navigationController?.pushViewController(photosVC, animated: true)
    }
}
