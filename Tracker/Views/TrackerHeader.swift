//
//  TrackerHeader.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 15.04.2024.
//

import UIKit

final class TrackerHeader: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .natural
        titleLabel.font = Resources.Fonts.sectionHeader
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
          titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Layouts.leadingSection),
          titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Layouts.vSpacingSection),
          titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Resources.Layouts.vSpacingTracker)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
