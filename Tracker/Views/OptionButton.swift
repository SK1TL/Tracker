//
//  OptionButton.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 14.04.2024.
//

import UIKit

final class OptionButton: UIButton {
    
    private lazy var primaryLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.numberOfLines = 1
        primaryLabel.textAlignment = .natural
        primaryLabel.textColor = .YPBlack
        primaryLabel.font = Resources.Fonts.textField
        return primaryLabel
    }()
    
    private lazy var secondLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.numberOfLines = 1
        secondLabel.textAlignment = .natural
        secondLabel.textColor = .YPBlack
        secondLabel.font = Resources.Fonts.textField
        secondLabel.isHidden = true
        return secondLabel
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = Resources.SfSymbols.chevron
        iconImageView.tintColor = .YPGray
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(primaryLabel)
        addSubview(secondLabel)
        addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        primaryLabel.text = title
    }
    
    func configure(value: String) {
        secondLabel.text = value
        secondLabel.isHidden = false
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hSpacing = Resources.Layouts.leadingElement
        let iconSize = Resources.Dimensions.smallIcon
        let labelHeight = iconSize
        
        iconImageView.frame = CGRect(
            x: frame.size.width - iconSize - hSpacing,
            y: (frame.size.height - iconSize / 2 ) / 2,
            width: iconSize / 3,
            height: iconSize / 2
        )
        
        if secondLabel.text == nil {
            primaryLabel.frame = CGRect(
                x: hSpacing,
                y: (frame.size.height - labelHeight ) / 2,
                width: frame.size.width - iconSize - hSpacing * 2,
                height: labelHeight
            )
        } else {
            primaryLabel.frame = CGRect(
                x: hSpacing,
                y: labelHeight / 2,
                width: frame.size.width - iconSize - hSpacing * 2,
                height: labelHeight
            )
            secondLabel.frame = CGRect(
                x: hSpacing,
                y: labelHeight + labelHeight / 2,
                width: frame.size.width - iconSize - hSpacing * 2,
                height: labelHeight
            )
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.addTarget(self, action: #selector(tapped), for: .touchDown)
        self.addTarget(self, action: #selector(untapped), for: .touchUpInside)
    }
    
    @objc private func tapped() {
        self.alpha = 0.7
    }
    
    @objc private func untapped() {
        self.alpha = 1
    }
}
