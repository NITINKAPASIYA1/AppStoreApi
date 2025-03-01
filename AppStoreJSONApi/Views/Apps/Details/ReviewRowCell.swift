//
//  ReviewRowCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 21/02/25.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let reviewsRatingsLabel: UILabel = {
        let label = UILabel(text: "Reviews & Ratings", font: .boldSystemFont(ofSize: 20))
        label.textColor = .label  // Adapts to dark mode
        return label
    }()
    
    lazy var reviewsController: ReviewsController = {
        let controller = ReviewsController()
        return controller
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground  // Adaptive background
        
        contentView.addSubview(reviewsRatingsLabel)
        contentView.addSubview(reviewsController.view)
        
        reviewsRatingsLabel.anchor(
            top: contentView.topAnchor, leading: contentView.leadingAnchor,
            bottom: nil, trailing: contentView.trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 20)
        )
        
        reviewsController.view.anchor(
            top: reviewsRatingsLabel.bottomAnchor, leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 0)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
