//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 12.04.2024.
//

import Foundation
import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func createTrackerViewController(
        _ viewController: CreateTrackerViewController,
        didFilledTracker tracker: Tracker,
        for categoryIndex: Int
    )
}

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    // MARK: - Variables for Title section
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = isHabit ? Resources.Labels.newHabit : Resources.Labels.newEvent
        titleLabel.font = Resources.Fonts.titleUsual
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: Resources.Dimensions.titleHeight + Resources.Layouts.vSpacingTitle
        )
        return titleLabel
    }()
    
    // MARK: - Variables for TextField section
    private lazy var textField: TextField = {
        let textField = TextField()
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = Resources.Dimensions.cornerRadius
        textField.layer.masksToBounds = true
        textField.placeholder = Resources.Labels.textFieldPlaceholder
        textField.clearButtonMode = .whileEditing
        textField.textColor = .YPBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame = CGRect(x: 0, y: 0, width: optionsViewWidth, height: Resources.Dimensions.fieldHeight)
        return textField
    }()
    
    private lazy var textFieldWarning: UILabel = {
        let textFieldWarning = UILabel()
        textFieldWarning.text = Resources.Labels.textFieldRestriction
        textFieldWarning.font = Resources.Fonts.textField
        textFieldWarning.textAlignment = .center
        textFieldWarning.textColor = .YPRed
//        textFieldWarning.text = "Ограничение 38 символов"
        textFieldWarning.translatesAutoresizingMaskIntoConstraints = false
        textFieldWarning.frame = CGRect(
            x: 0,
            y: Int(Resources.Dimensions.fieldHeight),
            width: Int(optionsViewWidth),
            height: Int(Resources.Dimensions.fieldHeight / 2)
        )
        return textFieldWarning
    }()
    
    // MARK: - Variables for Options section
    private lazy var optionView: UIView = {
        let optionView = UIView()
        optionView.backgroundColor = .ypBackground
        optionView.translatesAutoresizingMaskIntoConstraints = false
        optionView.layer.cornerRadius = Resources.Dimensions.cornerRadius
        optionView.layer.masksToBounds = true
        optionView.frame = CGRect(x: 0, y: 0, width: optionsViewWidth, height: optionsViewHeight)
        return optionView
    }()
    
    private lazy var categoryButton: OptionButton = {
        let categoryButton = OptionButton()
        categoryButton.configure(title: Resources.Labels.category)
        categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
        categoryButton.frame = CGRect(x: 0, y: 0, width: optionsViewWidth, height: Resources.Dimensions.fieldHeight)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        return categoryButton
    }()
    
    private lazy var dividerView: UIView = {
        let rectangleView = UIView()
        rectangleView.backgroundColor = .YPGray
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        return rectangleView
    }()
    
    private lazy var scheduleButton: OptionButton = {
        let scheduleButton = OptionButton()
        scheduleButton.configure(title: Resources.Labels.schedule)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonClicked), for: .touchUpInside)
        scheduleButton.frame = CGRect(x: 0, y: Resources.Dimensions.fieldHeight, width: optionsViewWidth, height: Resources.Dimensions.fieldHeight)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        return scheduleButton
    }()
    
    // MARK: - Variables for Buttons
    private lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.backgroundColor = .YPWhite
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = Resources.Layouts.hSpacingButton
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonStackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle(Resources.Labels.cancel, for: .normal)
        cancelButton.setTitleColor(.YPRed, for: .normal)
        cancelButton.backgroundColor = .YPWhite
        cancelButton.layer.borderColor = UIColor.YPRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = Resources.Dimensions.cornerRadius
        cancelButton.layer.masksToBounds = true
        cancelButton.titleLabel?.font = Resources.Fonts.titleUsual
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle(Resources.Labels.create, for: .normal)
        createButton.setTitleColor(.ypLightGray, for: .disabled)
        createButton.backgroundColor = .YPWhite
        createButton.layer.cornerRadius = Resources.Dimensions.cornerRadius
        createButton.layer.masksToBounds = true
        createButton.titleLabel?.font = Resources.Fonts.titleUsual
        createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private lazy var safeArea: UILayoutGuide = {
        view.safeAreaLayoutGuide
    }()
    
    private lazy var buttonsStackViewWidth: CGFloat = {
        view.frame.width - 2 * Resources.Layouts.leadingButton
    }()
    
    private lazy var optionsViewWidth: CGFloat = {
        view.frame.width - 2 * Resources.Layouts.leadingElement
    }()
    
    private lazy var optionsViewHeight: CGFloat = {
        return isHabit ? Resources.Dimensions.fieldHeight * 2 : Resources.Dimensions.fieldHeight
    }()
    
    private lazy var leadSpacing: CGFloat = {
        Resources.Layouts.leadingElement
    }()
    
    private var trackerNameIsFulfilled = false {
        didSet {
            updateFormState()
        }
    }
    
    private var categoryIsSelected = false {
        didSet {
            updateFormState()
        }
    }
    
    private var scheduleIsFulfilled = false {
        didSet {
            updateFormState()
        }
    }
    
    private var emojiIsSelected = true // dummy for now, add didSet after implementation emojis
    private var colorIsSelected = true // dummy for now, add didSet after implementation colours
    
    private var formIsFulfilled = false {
        didSet {
            if formIsFulfilled {
                updateCreateButtonState()
            }
        }
    }
    
    private let factory = TrackersFactory.shared
    private var selectedCategoryIndex = 0
    private var isHabit: Bool
    private var schedule = [WeekDay]()
    private var userInput = "" {
        didSet {
            trackerNameIsFulfilled = true
        }
    }
    
    init(isHabit: Bool) {
        self.isHabit = isHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if !isHabit {
            scheduleIsFulfilled = true
        }
        view.backgroundColor = .YPWhite
        configureUI()
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    private func configureUI() {
        configureTitleLabel()
        configureTextFieldSection()
        configureOptionsSection()
        configureButtonSection()
    }
    
    // MARK: - Configure Title section
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        makeTitleLabelConstraints()
    }
    
    private func makeTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Configure TextField section
    private func configureTextFieldSection() {
        view.addSubview(textField)
        view.addSubview(textFieldWarning)
        makeTextFieldConstraints()
        makeTextFieldWarningConstraints()
    }
    
    private func makeTextFieldConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Layouts.vSpacingElement),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            textField.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight)
        ])
    }
    
    private func makeTextFieldWarningConstraints() {
        NSLayoutConstraint.activate([
            textFieldWarning.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            textFieldWarning.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            textFieldWarning.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45)
        ])
    }
    
    // MARK: - Configure Options section
    private func configureOptionsSection() {
        configureOptionView()
        configureCategoryButton()
        if isHabit {
            configureDividerView()
            configureScheduleButton()
        }
    }
    
    private func configureOptionView() {
        view.addSubview(optionView)
        NSLayoutConstraint.activate([
            optionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
            optionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
            optionView.heightAnchor.constraint(equalToConstant: optionsViewHeight),
            optionView.topAnchor.constraint(
                equalTo: textFieldWarning.bottomAnchor,
                constant: Resources.Layouts.vSpacingElement
            )
        ])
    }
    
    private func configureCategoryButton() {
        optionView.addSubview(categoryButton)
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: optionView.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func configureDividerView() {
        optionView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            dividerView.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: Resources.Layouts.leadingElement),
            dividerView.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -Resources.Layouts.leadingElement)
        ])
    }
    
    private func configureScheduleButton() {
        optionView.addSubview(scheduleButton)
        NSLayoutConstraint.activate([
            scheduleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75)
            
        ])
    }
    
    // MARK: - Configure Buttons section
    private func configureButtonSection() {
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
        updateCreateButtonState()
        makeButtonsStackViewConstraints()
    }
    
    private func makeButtonsStackViewConstraints() {
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: buttonsStackViewWidth),
            buttonStackView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
            buttonStackView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -Resources.Layouts.vSpacingButton
            )
        ])
    }
    
    // MARK: - Private methods
    private func updateFormState() {
        formIsFulfilled = trackerNameIsFulfilled && categoryIsSelected && scheduleIsFulfilled 
    }
    
    private func updateCreateButtonState() {
        createButton.backgroundColor = formIsFulfilled ? .YPBlack : .YPGray
        createButton.isEnabled = formIsFulfilled
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func createButtonClicked() {
        let newTracker = Tracker(
            id: UUID(),
            title: userInput,
            emoji: Int.random(in: 0...17), //dummy
            color: Int.random(in: 0...17), //dummy
            schedule: schedule
        )
        delegate?.createTrackerViewController(self, didFilledTracker: newTracker, for: selectedCategoryIndex)
    }
    
    @objc func scheduleButtonClicked() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    @objc func categoryButtonClicked() { // TODO: Make VC to select category and return it here by selectedCategoryIndex
        selectedCategoryIndex = Int.random(in: 0..<factory.categories.count) // dummy for categoryIndex
        let selectedCategory = factory.categories[selectedCategoryIndex]
        categoryButton.configure(value: selectedCategory.name)
        categoryIsSelected = true
    }
}

extension CreateTrackerViewController: UITextFieldDelegate {
    private func textField(
        _ textField: UITextField,
        shouldChangeCharectersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        userInput = textField.text ?? ""
        let currentCharecterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharecterCount {
            return false
        }
        let newLength = currentCharecterCount + string.count - range.length
        if newLength >= Resources.textFieldLimit {
            textFieldWarning.isHidden = false
        } else {
            textFieldWarning.isHidden = true
        }
        return newLength <= Resources.textFieldLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        userInput = textField.text ?? ""
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }
    
    func getScheduleShortNames(from schedule: [WeekDay]) -> String {
        if schedule == WeekDay.allCases {
            return "Каждый день"
        }
        if schedule == [.monday, .tuesday, .wednesday, .thursday, .friday] {
            return "Будние дни"
        }
        return schedule
            .map { $0.shortName }
            .joined(separator: ", ")
    }
}

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ schedule: [WeekDay]) {
        scheduleButton.configure(value: getScheduleShortNames(from: schedule))
        self.schedule = schedule
        scheduleIsFulfilled = true
        dismiss(animated: true)
    }
}
