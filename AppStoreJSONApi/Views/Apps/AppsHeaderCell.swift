//
//  AppsHeaderCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 19/02/25.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    var app: SocialApp! {
        didSet {
            companyLabel.text = app.name
            titleLabel.text = app.tagline
            imageView.sd_setImage(with: URL(string: app.imageUrl))
        }
    }
    
    let companyLabel: UILabel = {
        let label = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
        label.textColor = .systemBlue
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(cornerRadius: 16)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .tertiarySystemFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground  // Adaptive background
        
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, imageView], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

