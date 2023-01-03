//
//  TableViewCell.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 03.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reduseId = "MenuTableViewCell"
    
    //MARK: - Outlets
    
    let label: UILabel = {
        let obj = UILabel()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.textColor = .black
        return obj
    }()
    
    let iconImageView: UIImageView = {
        let obj = UIImageView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.contentMode = .scaleAspectFill
        obj.layer.cornerRadius = 20
        obj.clipsToBounds = true
        return obj
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(self.iconImageView)
        addSubview(self.label)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupLayout
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 3),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
            
        ])
    }
}

