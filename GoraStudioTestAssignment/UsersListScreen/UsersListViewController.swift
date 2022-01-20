//
//  UsersListViewController.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

final class UsersListViewController: UIViewController {
    // MARK: - ViewModel
    let viewModel: UsersListViewModelProtocol = UsersListViewModel()

    // --UI Props
    lazy var usersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = viewModel as! UsersListViewModel
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.register(CommonCell.self, forCellReuseIdentifier: CommonCell.identifier)
        tableView.toAutoLayout()
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        viewModel.errorHandler = { [weak self] error in
            self?.alert(error: error)
        }

        viewModel.usersListLoaded = {[weak usersTableView] in
            DispatchQueue.main.async {
                usersTableView?.reloadData()
            }
        }
        setupAutoLayout()
        viewModel.loadUsersList()
    }

    // MARK: - Setting constraints
    private func setupAutoLayout() {
        view.addSubview(usersTableView)
        NSLayoutConstraint.activate([
            usersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            usersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableView delegate methods
extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.prepareViewModelForAlbumsScreen(atIndexPath: indexPath)
        let albumsVC = AlbumsListsViewController(withViewModel: viewModel)
        navigationController?.pushViewController(albumsVC, animated: true)
    }
}
