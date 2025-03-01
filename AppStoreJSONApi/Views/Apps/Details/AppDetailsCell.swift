//
//  AppDetailsCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 21/02/25.
//

import UIKit

class AppDetailsCell: UICollectionViewCell {
    
    var app: Result? {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceButton.setTitle(app?.formattedPrice, for: .normal)
        }
    }
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView(cornerRadius: 16)
        iv.backgroundColor = .tertiarySystemFill
        iv.constrainWidth(constant: 140)
        iv.constrainHeight(constant: 140)
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
        label.textColor = .label
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton(title: "$4.99")
        button.backgroundColor = .systemBlue
        button.constrainHeight(constant: 32)
        button.constrainWidth(constant: 80)
        button.layer.cornerRadius = 32 / 3
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let whatsNewLabel: UILabel = {
        let label = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
        label.textColor = .label
        return label
    }()
    
    let releaseNotesLabel: UILabel = {
        let label = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground  // Adaptive background
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                appIconImageView,
                VerticalStackView(arrangedSubviews: [
                    nameLabel,
                    UIStackView(arrangedSubviews: [priceButton, UIView()]),
                    UIView()
                ], spacing: 12)
            ], customSpacing: 20),
            whatsNewLabel,
            releaseNotesLabel
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}

#Preview {
    AppDetailsCell()
}
