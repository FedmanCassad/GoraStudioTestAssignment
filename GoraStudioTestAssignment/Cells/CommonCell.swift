//
//  CommonCell.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

final class CommonCell: UITableViewCell {
    // -- Identifier for registering
    static let identifier = String(describing: CommonCell.self)

    // MARK: - UI props
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.toAutoLayout()
        return label
    }()

    // -- Decided to avoid using viewModel due to extremely simple UI.
    func configure(with text: String) {
        label.text = text
        label.font = .systemFont(ofSize: 24)
        setupAutoLayout()
    }
    // MARK: - AutoLayout stuff
    private func setupAutoLayout() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate ([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
