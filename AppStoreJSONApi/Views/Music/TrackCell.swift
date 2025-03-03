//
//  TrackCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 26/02/25.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8  // More subtle rounded corners
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.constrainWidth(constant: 75)
        iv.constrainHeight(constant: 75)
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label  // Adapts for Dark Mode
        label.numberOfLines = 1
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel  // Softer text color
        label.numberOfLines = 1
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear  // Matches Apple's UI style
        
        let textStackView = UIStackView(arrangedSubviews: [nameLabel, subTitleLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        
        let horizontalStackView = UIStackView(arrangedSubviews: [imageView, textStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .center
        
        addSubview(horizontalStackView)
        addSubview(separatorView)
        
        horizontalStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 16, bottom: 0, right: 16))
        
        separatorView.anchor(top: horizontalStackView.bottomAnchor, leading: textStackView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
