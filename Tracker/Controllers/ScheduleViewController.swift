//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 13.04.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleViewController(_ viewController: ScheduleViewController, didSelectSchedule schedule: [Bool])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Resources.Labels.schedule
        titleLabel.font = Resources.Fonts.titleUsual
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(view.frame.width),
            height: Int(Resources.Dimensions.titleHeight + Resources.Layouts.vSpacingTitle))
        return titleLabel
    }()
    
    private lazy var optionsView: UIView = {
        let optionsView = UIView()
        optionsView.backgroundColor = .ypBackground
        optionsView.layer.cornerRadius = Resources.Dimensions.cornerRadius
        optionsView.layer.masksToBounds = true
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        optionsView.frame = CGRect(
            x: 0,
            y: 0,
            width: optionsViewWidth,
            height: optionsViewHeight
        )
        return optionsView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton()
        doneButton.setTitle(Resources.Labels.done, for: .normal)
        doneButton.setTitleColor(.YPLightGray, for: .disabled)
        doneButton.titleLabel?.font = Resources.Fonts.titleUsual
        doneButton.backgroundColor = .ypBlack
        doneButton.layer.cornerRadius = Resources.Dimensions.cornerRadius
        doneButton.layer.masksToBounds = true
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    
    private lazy var safeArea: UILayoutGuide = {
        view.safeAreaLayoutGuide
    }()
    
    private lazy var buttonWidth: CGFloat = {
        view.frame.width - 2 * Resources.Layouts.leadingButton
    }()
    
    private lazy var optionsViewWidth: CGFloat = {
        view.frame.width - 2 * Resources.Layouts.leadingElement
    }()
    
    private lazy var optionsViewHeight: CGFloat = {
        return Resources.Dimensions.fieldHeight * CGFloat(daysOfWeek)
    }()
    
    private lazy var leadSpacing: CGFloat = {
        Resources.Layouts.leadingElement
    }()
    
    private lazy var switchWidth: CGFloat = {
        switchHeight * 2
    }()
    
    private lazy var switchHeight: CGFloat = {
        return Resources.Dimensions.fieldHeight / 3
    }()
    
    private lazy var formIsFulfilled = false {
        didSet {
            updateDoneButtonState()
        }
    }
    
    private var schedule: [Bool]
    private let daysOfWeek = 7
    private let weekDays = [
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота",
        "Воскресенье"
    ]
    
    // MARK: - Inits
    init(schedule: [Bool]) {
        self.schedule = schedule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        configureUI()
    }
    
    private func configureUI() {
        configureTitleLabel()
        configureOptionsView()
        configureDoneButton()
    }
    
    // MARK: - Configure Title section
    
    private func configureTitleLabel() {
        addTitleSubviews()
        makeTitleConstraints()
    }
    
    private func addTitleSubviews() {
        view.addSubview(titleLabel)
    }
    
    private func makeTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
            titleLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    // MARK: - Configure Options section
    
    func configureOptionsSection() {
        configureOptionsView()
        addOptionViewSubviews()
        makeOptionsSectionConstraints()
        for day in 0..<daysOfWeek {
            configureOptionsLabel(index: day)
            configureOptionsSwitch(index: day)
        }
        let borderView = BorderView()
        borderView.configure(
            for: optionsView,
            width: optionsViewWidth - Resources.Layouts.leadingElement * 2,
            repeat: daysOfWeek - 1
        )
    }
    
    func addOptionViewSubviews() {
        view.addSubview(optionsView)
    }
    
    func configureOptionsView() {
        optionsView.backgroundColor = .ypBackground
        optionsView.layer.cornerRadius = Resources.Dimensions.cornerRadius
        optionsView.layer.masksToBounds = true
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        optionsView.frame = CGRect(
            x: 0,
            y: 0,
            width: optionsViewWidth,
            height: optionsViewHeight
        )
    }
    
    func configureOptionsLabel(index: Int) {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = weekDays[index]
        label.textAlignment = .natural
        label.frame = CGRect(
            x: leadSpacing,
            y: Resources.Dimensions.fieldHeight * CGFloat(index),
            width: optionsViewWidth,
            height: Resources.Dimensions.fieldHeight
        )
        optionsView.addSubview(label)
    }
    
    func configureOptionsSwitch(index: Int) {
        let daySwitch = UISwitch()
        daySwitch.isOn = schedule[index]
        daySwitch.tag = index
        daySwitch.thumbTintColor = .YPWhite
        daySwitch.onTintColor = .YPBlue
        daySwitch.addTarget(self, action: #selector(onSwitchChange(_:)), for: .touchUpInside)
        daySwitch.frame = CGRect(
            x: optionsViewWidth - leadSpacing - switchWidth,
            y: Resources.Dimensions.fieldHeight * CGFloat(index) + switchHeight,
            width: switchWidth,
            height: switchHeight
        )
        optionsView.addSubview(daySwitch)
    }
    
    func makeOptionsSectionConstraints() {
        NSLayoutConstraint.activate([
            optionsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Layouts.vSpacingElement),
            optionsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadSpacing),
            optionsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leadSpacing),
            optionsView.heightAnchor.constraint(equalToConstant: optionsViewHeight)
        ])
    }
    
    // MARK: - Configure Button section
    
    private func configureDoneButton() {
        addButtonSubviews()
        updateFormState()
        updateDoneButtonState()
        makeDoneButtonConstraints()
    }
    
    func updateFormState() {
        formIsFulfilled = !schedule.filter { $0 == true }.isEmpty
    }
    
    func updateDoneButtonState() {
        doneButton.backgroundColor = formIsFulfilled ? .YPBlack : .YPGray
        doneButton.isEnabled = formIsFulfilled ? true : false
    }
    
    private func addButtonSubviews() {
        view.addSubview(doneButton)
    }
    
    private func makeDoneButtonConstraints() {
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            doneButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
            doneButton.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor,
                constant: -Resources.Layouts.vSpacingButton
            )
        ])
    }
    
    //MARK: - Action buttons configure
    
    @objc func doneButtonClicked() {
        delegate?.scheduleViewController(self, didSelectSchedule: schedule)
    }
    
    @objc func onSwitchChange(_ sender: UISwitch) {
        schedule[sender.tag] = sender.isOn
        updateFormState()
    }
}
