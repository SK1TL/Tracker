//
//  Trackers.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 11.04.2024.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    private var titleView: UIView {
        let titleView = UIView()
        titleView.layer.cornerRadius = Resources.Dimensions.cornerRadius
        titleView.layer.masksToBounds = true
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }
    
    
}
