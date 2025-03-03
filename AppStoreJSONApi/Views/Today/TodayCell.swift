//
//  TodayCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 22/02/25.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
            
            // Ensure titleLabel remains black for holiday and Life hack  cells thik h
            if todayItem.category == "HOLIDAYS" || todayItem.category == "LIFE HACK" {
                titleLabel.textColor = .black
                categoryLabel.textColor = .black
                descriptionLabel.textColor = .black
            } else {
                titleLabel.textColor = .label  // Adapts to light/dark mode
                categoryLabel.textColor = .label
                descriptionLabel.textColor = .secondaryLabel
            }
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label // Adapts to light/dark mode
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor.label
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "garden"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.systemBackground // Adapts to light/dark mode
        layer.cornerRadius = 16
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, imageContainerView, descriptionLabel
        ], spacing: 8)
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24))
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
