//
//  CharacterDetailsCell.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 02.01.2024.
//

import UIKit

class CharacterDetailsCell: UITableViewCell {
    let titleLabel = UILabel()
    let detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    func setupSubviews() {
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        detailLabel.font = UIFont.systemFont(ofSize: 15)
        detailLabel.textColor = UIColor.gray
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}
