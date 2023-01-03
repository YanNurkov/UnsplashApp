//
//  PhotoCollectionViewCell.swift
//  UnsplashApp
//
//  Created by Ян Нурков on 02.01.2023.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    // MARK: - Outlets
    
    lazy var imageView: UIImageView = {
        let obj = UIImageView()
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.frame = self.bounds
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigurationView
    
    func configView() {
        imageView.layer.shadowRadius = 6
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
