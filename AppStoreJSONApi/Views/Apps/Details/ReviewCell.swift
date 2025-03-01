//
//  ReviewCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 21/02/25.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
    
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    
    let startLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let startStackView : UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { (_) in
            let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
            imageView.tintColor = .systemOrange
            imageView.constrainWidth(constant: 20)
            imageView.constrainHeight(constant: 20)
            arrangedSubviews.append(imageView)
        }
        
        arrangedSubviews.append(UIView())
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        return stackView
        
    }()
    
    let bodyLabel  = UILabel(text: "Review Body\nReview Body\nReview Body\nReview Body\n",font: .systemFont(ofSize: 16),numberOfLines: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel,UIView(),authorLabel
            ]),
            startStackView,
            bodyLabel,
        ],spacing: 12)
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        
        addSubview(stackView)
//        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
