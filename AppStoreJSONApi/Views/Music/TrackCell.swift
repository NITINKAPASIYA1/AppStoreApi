//
//  TrackCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 26/02/25.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 20))
    let subTitleLabel = UILabel(text: "Artist Name", font: .systemFont(ofSize: 16))
    
    // Thin separator line
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.constrainWidth(constant: 60)
        imageView.constrainHeight(constant: 60)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let textStackView = VerticalStackView(arrangedSubviews: [nameLabel, subTitleLabel], spacing: 2)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [imageView, textStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 16
        horizontalStackView.alignment = .center
        
        addSubview(horizontalStackView)
        addSubview(separatorView)
        
        horizontalStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 16, bottom: 0, right: 16))
        
        separatorView.anchor(top: horizontalStackView.bottomAnchor, leading: textStackView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor ,padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
