//
//  MultipleAppCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 24/02/25.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            nameLabel.text = app.name
            companyLabel.text = app.artistName
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    let imageView = UIImageView(cornerRadius: 8)
    
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    
    let companyLabel = UILabel(text: "Company Label", font: .systemFont(ofSize: 13))
    
    let getButton = UIButton(title: "GET")
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        return view
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        imageView.backgroundColor = .black
        imageView.constrainWidth(constant: 55)
        imageView.constrainHeight(constant: 55)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 65)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 32/2
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel,companyLabel]),getButton])
        stackView.spacing = 16
        
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: -5, right: 0),size: .init(width: 0, height: 0.5))
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
