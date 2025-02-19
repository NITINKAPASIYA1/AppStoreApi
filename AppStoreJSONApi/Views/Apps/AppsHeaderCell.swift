//
//  AppsHeaderCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 19/02/25.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    let companyLabel  = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    let titleLabel = UILabel(text: "Keeping up with friends is faster and ever", font: .systemFont(ofSize: 24))
    
    let imageView = UIImageView(cornerRadius: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        companyLabel.textColor = .blue
        imageView.backgroundColor = .systemPink
        titleLabel.numberOfLines = 2
        
        imageView.contentMode = .scaleAspectFill

        
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel,titleLabel,imageView],spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
