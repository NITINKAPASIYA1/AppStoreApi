//
//  PreviewCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 21/02/25.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    
    let previewLabel: UILabel = {
        let label = UILabel(text: "Preview", font: .boldSystemFont(ofSize: 20))
        label.textColor = .label 
        return label
    }()
    
    let horizontalController = PreviewScreenshotsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(previewLabel)
        contentView.addSubview(horizontalController.view)
        
        previewLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor,
                            bottom: nil, trailing: contentView.trailingAnchor,
                            padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        horizontalController.view.anchor(top: previewLabel.bottomAnchor, leading: contentView.leadingAnchor,
                                         bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,
                                         padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
