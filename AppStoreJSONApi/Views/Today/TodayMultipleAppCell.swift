//
//  TodayMultipleAppCell.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 24/02/25.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            
            multipleAppController.apps = todayItem.apps
            multipleAppController.collectionView.reloadData()
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label // Adapts to dark mode
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    let multipleAppController = TodayMultipleAppsController(mode: .small)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        configureForCurrentTraitCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 16
        backgroundColor = .systemBackground // Adapts to dark mode
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, multipleAppController.view
        ], spacing: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureForCurrentTraitCollection()
        }
    }
    
    private func configureForCurrentTraitCollection() {
        backgroundColor = .systemBackground
        categoryLabel.textColor = .label
        titleLabel.textColor = .label
    }
}
