//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 16.04.2024.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    
    static let reuseIdentifier = "ScheduleCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .YPBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleSwitch: UISwitch = {
        let scheduleSwitch = UISwitch()
        scheduleSwitch.translatesAutoresizingMaskIntoConstraints = false
        scheduleSwitch.onTintColor = .YPBlue
        scheduleSwitch.addTarget(self, action: #selector(onSwitchAction), for: .valueChanged)
        return scheduleSwitch
    }()
    
    var onSwitchCallback: ((Bool) -> (Void))?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .YPLightGray.withAlphaComponent(0.3)
        selectionStyle = .none
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(scheduleSwitch)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Resources.Layouts.leadingElement),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            scheduleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Resources.Layouts.leadingElement),
            scheduleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func onSwitchAction() {
        onSwitchCallback?(scheduleSwitch.isOn)
    }
    
    func configureCell(title: String, isOn: Bool) {
        titleLabel.text = title
        scheduleSwitch.isOn = isOn
    }
}
