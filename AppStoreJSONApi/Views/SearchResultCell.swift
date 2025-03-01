//
//  SearchResultCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 17/02/25.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    
    var appResult : Result! {
        didSet {
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            
            if let rating = appResult.averageUserRating {
                ratingLabel.text = String(format: "Rating: %.1f", rating)
            } else {
                ratingLabel.text = "Rating: 0.00"
            }
            
            
            appIconImageView.sd_setImage(with: URL(string: appResult.artworkUrl100))
            
            if appResult.screenshotUrls.count == 0 {
                return 
            }
            
            screenShot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
            
            
            
            if appResult.screenshotUrls.count > 1 {
                screenShot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
            }
            if appResult.screenshotUrls.count > 2 {
                screenShot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
            }
        }
    }
    
    
    
    //Closure Property so you need to call is by () at last for execution
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "APP NAME"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos & Videos"
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "9.12M"
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.systemBlue, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .init(white: 0.7, alpha: 0.2)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.layer.cornerRadius = 14
        return button
    }()
    
    lazy var screenShot1ImageView = self.createScreenShotImageView()
    lazy var screenShot2ImageView = self.createScreenShotImageView()
    lazy var screenShot3ImageView = self.createScreenShotImageView()
        
    
    func createScreenShotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Optional
        let labelStackView = VerticalStackView(arrangedSubviews: [
            nameLabel,categoryLabel,ratingLabel
        ])
        
        
        let infoTopStackView = UIStackView(arrangedSubviews: [appIconImageView,labelStackView,getButton])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        let screenShotStackView = UIStackView(arrangedSubviews: [screenShot1ImageView,screenShot2ImageView,screenShot3ImageView])
        screenShotStackView.spacing = 12
        screenShotStackView.distribution = .fillEqually
        
        let overStackView = UIStackView(arrangedSubviews: [infoTopStackView,screenShotStackView,])
        overStackView.axis = .vertical
        overStackView.spacing = 16
        
        addSubview(overStackView)
        overStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
