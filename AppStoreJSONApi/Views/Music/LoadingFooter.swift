//
//  LoadingFooter.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 26/02/25.
//

import UIKit

class LoadingFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        
        let label = UILabel(text: "Loading...", font: .systemFont(ofSize: 16))
        label.textAlignment = .center
        
        let stackView = VerticalStackView(arrangedSubviews: [
            aiv,label
        ],spacing: 8)
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 30, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
