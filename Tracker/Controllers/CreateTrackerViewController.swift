//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 12.04.2024.
//

import Foundation
import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Resources.Labels.newTracker
        titleLabel.font = Resources.Fonts.titleUsual
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
}
