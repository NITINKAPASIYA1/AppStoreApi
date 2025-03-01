//
//  AppRowCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 19/02/25.
//

import UIKit


class AppRowCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            nameLabel.text = app.name
            companyLabel.text = app.artistName
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(cornerRadius: 8)
        iv.backgroundColor = .tertiarySystemFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
        label.textColor = .label
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel(text: "Company Label", font: .systemFont(ofSize: 13))
        label.textColor = .secondaryLabel
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(title: "GET")
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.constrainWidth(constant: 65)
        button.constrainHeight(constant: 32)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground  // Adaptive cell background
        
        imageView.constrainWidth(constant: 55)
        imageView.constrainHeight(constant: 55)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [nameLabel, companyLabel]),
            getButton
        ])
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    

#Preview{
    AppRowCell()
}
