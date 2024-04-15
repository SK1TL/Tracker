//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 11.04.2024.
//

import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func newTrackerViewController(_ viewController: NewTrackerViewController, didFilledTracker tracker: Tracker, for categoryIndex: Int)
}

final class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Resources.Labels.newTracker
        titleLabel.font = Resources.Fonts.titleUsual
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Resources.Layouts.vSpacingButton
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var newHabitButton: UIButton = {
        let newHabitButton = UIButton()
        newHabitButton.tintColor = .YPWhite
        newHabitButton.backgroundColor = .YPBlack
        newHabitButton.setTitle(Resources.Labels.habit, for: .normal)
        newHabitButton.addTarget(self, action: #selector(newHabitButtonClicked), for: .touchUpInside)
        newHabitButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(newHabitButton)
        return newHabitButton
    }()
    
    private lazy var newEventButton: UIButton = {
        let newEventButton = UIButton()
        newEventButton.tintColor = .YPWhite
        newEventButton.backgroundColor = .YPBlack
        newEventButton.setTitle(Resources.Labels.event, for: .normal)
        newEventButton.addTarget(self, action: #selector(newEventButtonClicked), for: .touchUpInside)
        newEventButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(newEventButton)
        return newEventButton
    }()
    
    private lazy var safeArea: UILayoutGuide = {
        view.safeAreaLayoutGuide
    }()
    
    private lazy var stackWidth: CGFloat = {
        view.frame.width - 2 * Resources.Layouts.leadingButton
    }()
    
    private lazy var stackHeight: CGFloat = {
        2 * Resources.Dimensions.buttonHeight + Resources.Layouts.vSpacingButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        
        configureTitleView()
        configureStackView()
    }
    
    // MARK: - Configure Title section
    private func configureTitleView() {
        addTitleSubviews()
        configureTitleConstraints()
    }
    
    private func addTitleSubviews() {
        view.addSubview(titleLabel)
    }
    
    private func configureTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle)
        ])
    }
    
    // MARK: - Configure Stack section
    private func configureStackView() {
        addStackViewSubviews()
        configureStackViewConstraints()
    }
    
    private func addStackViewSubviews() {
        stackView.addSubview(stackView)
        stackView.addSubview(newEventButton)
        stackView.addSubview(newHabitButton)
    }
    
    private func configureStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: stackHeight),
            stackView.widthAnchor.constraint(equalToConstant: stackWidth)
        ])
    }
    
    @objc func newHabitButtonClicked() {
        let createTrackerVC = CreateTrackerViewController(isHabit: true)
        createTrackerVC.delegate = self
        present(createTrackerVC, animated: true)
    }
    
    @objc func newEventButtonClicked() {
        let createTrackerVC = CreateTrackerViewController(isHabit: false)
        createTrackerVC.delegate = self
        present(createTrackerVC, animated: true)
    }
}

extension NewTrackerViewController: CreateTrackerViewControllerDelegate {
  func createTrackerViewController(_ viewController: CreateTrackerViewController, didFilledTracker tracker: Tracker, for categoryIndex: Int) {
    delegate?.newTrackerViewController(self, didFilledTracker: tracker, for: categoryIndex)
  }
}
