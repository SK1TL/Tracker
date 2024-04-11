//
//  EmptyView.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 07.04.2024.
//

import UIKit

final class EmptyView: UIView {
    
    private lazy var emptyView: UIImageView = {
        let emptyView = UIImageView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(emptyView)
        addSubview(label)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalToConstant: 80),
            emptyView.heightAnchor.constraint(equalToConstant: 80),
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyView.topAnchor.constraint(equalTo: self.topAnchor),
            
            label.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureView(image: UIImage, text: String) {
        emptyView.image = image
        label.text = text
    }
}
