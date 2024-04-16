//
//  Trackers.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 11.04.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapDone(for cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    private var titleView: UIView {
        let titleView = UIView()
        titleView.layer.cornerRadius = Resources.Dimensions.cornerRadius
        titleView.layer.masksToBounds = true
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.textColor = .YPWhite
        label.font = Resources.Fonts.textNotification
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .YPWhite
        label.font = Resources.Fonts.textNotification
        label.backgroundColor = .YPWhiteAlpha
        label.layer.cornerRadius = Resources.Dimensions.mediumCornerRadius
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .YPBlack
        label.font = Resources.Fonts.textNotification
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Resources.Dimensions.cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(TrackerCell.self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var counterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resources.SfSymbols.addCounter
        imageView.tintColor = .YPWhite
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTrackerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func makeItDone(_ isCompleted: Bool) {
        counterImageView.image = isCompleted ? Resources.SfSymbols.doneCounter : Resources.SfSymbols.addCounter
        counterButton.alpha = isCompleted ? 0.7 : 1
    }
    
    func configureCell(bgColor: UIColor, emoji: String, title: String, counter: Int) {
        titleView.backgroundColor = bgColor
        counterButton.backgroundColor = bgColor
        titleLabel.text = title
        emojiLabel.text = emoji
        updateCounter(counter)
    }
    
    func updateCounter(_ counter: Int) {
      switch counter {
      case _ where (1 == counter % 10) && !(10...19 ~= counter % 100):
        counterLabel.text = String(counter) + " " + Resources.Labels.oneDay
      case _ where (2...4 ~= counter % 10) && !(10...19 ~= counter % 100):
        counterLabel.text = String(counter) + " " + Resources.Labels.fewDays
      default:
        counterLabel.text = String(counter) + " " + Resources.Labels.manyDays
      }
    }
    
    private func configureTrackerCell() {
        addSubviews()
        makeTrackerCellConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(titleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(counterButton)
        contentView.addSubview(counterLabel)
        contentView.addSubview(counterImageView)
    }
    
    private func makeTrackerCellConstraints() {
        NSLayoutConstraint.activate([
          titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
          titleView.trailingAnchor.constraint(equalTo: trailingAnchor),
          titleView.topAnchor.constraint(equalTo: topAnchor),
          titleView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.trackerContentHeight),
          
          emojiLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: Resources.Layouts.leadingTracker),
          emojiLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: Resources.Layouts.leadingTracker),
          emojiLabel.widthAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),
          emojiLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),
          
          titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: Resources.Layouts.leadingTracker),
          titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -Resources.Layouts.leadingTracker),
          titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: Resources.Layouts.hSpacingButton),
          titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -Resources.Layouts.leadingTracker),
          
          counterButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Resources.Layouts.hSpacingButton),
          counterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Layouts.leadingTracker),
          counterButton.widthAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),
          counterButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),
          
          counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Layouts.leadingTracker),
          counterLabel.trailingAnchor.constraint(equalTo: counterButton.leadingAnchor, constant: -Resources.Layouts.hSpacingButton),
          counterLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Resources.Layouts.leadingElement),
          counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Resources.Layouts.leadingTracker * 2),
          
          counterImageView.centerXAnchor.constraint(equalTo: counterButton.centerXAnchor),
          counterImageView.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
          counterImageView.widthAnchor.constraint(equalToConstant: Resources.Layouts.leadingTracker),
          counterImageView.heightAnchor.constraint(equalToConstant: Resources.Layouts.leadingTracker)
        ])
    }
    
    @objc private func didTapDoneButton() {
        delegate?.trackerCellDidTapDone(for: self)
    }
}
