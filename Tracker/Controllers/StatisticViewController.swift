//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 07.04.2024.
//

import Foundation
import UIKit

final class StatisticViewController: UIViewController {
    
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Resources.Labels.statistic
        view.backgroundColor = .YPWhite
        
        addSubviews()
        makeConstraints()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .YPBlack
        
        guard let emptyStatisticImage = Resources.Images.emptyStatistic else { return }
        emptyView.configureView(image: emptyStatisticImage, text: Resources.Labels.emptyStatistic)
    }
    
    
    private func addSubviews() {
        view.addSubview(emptyView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
