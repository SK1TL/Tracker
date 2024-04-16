//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 13.04.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(_ schedule: [WeekDay])
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
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
        tableView.separatorColor = .YPGray
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var safeArea: UILayoutGuide = {
        view.safeAreaLayoutGuide
    }()
    
    private lazy var buttonWidth: CGFloat = {
        view.frame.width - 2 * Resources.Layouts.leadingButton
    }()
    
    private lazy var leadSpacing: CGFloat = {
        Resources.Layouts.leadingElement
    }()
    
    private lazy var formIsFulfilled = false {
        didSet {
            updateDoneButtonState()
        }
    }
    
    private lazy var selectedWeekDays: [Bool] = [Bool](repeating: false, count: weekDays.count)
    
    private let weekDays = WeekDay.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        configureUI()
    }
    
    private func configureUI() {
        configureTitleLabel()
        configureTableView()
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
    
    private func configureTableView() {
        view.addSubview(scheduleTableView)
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Layouts.vSpacingElement),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resources.Layouts.leadingElement),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resources.Layouts.leadingElement),
            scheduleTableView.heightAnchor.constraint(
                equalToConstant: Resources.Dimensions.scheduleCellHeight * CGFloat(weekDays.count)
            )
        ])
        scheduleTableView.tableFooterView = UIView()
    }
    
    // MARK: - Configure Button section
    
    private func configureDoneButton() {
        addButtonSubviews()
        updateFormState()
        updateDoneButtonState()
        makeDoneButtonConstraints()
    }
    
    func updateFormState() {
        formIsFulfilled = !selectedWeekDays.filter { $0 }.isEmpty
    }
    
    func updateDoneButtonState() {
        doneButton.backgroundColor = formIsFulfilled ? .YPBlack : .YPGray
        doneButton.isEnabled = formIsFulfilled
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
        var result: [WeekDay] = []
        for (index, val) in selectedWeekDays.enumerated() where val == true {
            result.append(weekDays[index])
        }
        delegate?.didSelectSchedule(result)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ScheduleCell.reuseIdentifier,
                for: indexPath
            ) as? ScheduleCell
        else {
            return UITableViewCell()
        }
        cell.configureCell(title: weekDays[indexPath.row].name, isOn: selectedWeekDays[indexPath.row])
        cell.onSwitchCallback = { [weak self] in
            guard let self else {
                return
            }
            selectedWeekDays[indexPath.row] = $0
            updateFormState()
        }
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Resources.Dimensions.scheduleCellHeight
    }
}
