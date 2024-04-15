//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 06.04.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
//    private lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//        collectionView.register(Tracker, forCellWithReuseIdentifier: <#T##String#>)
//        
//    }
    
//    var trackers: [Tracker] {
//        didSet {
//            emptyView.isHidden = !trackers.isEmpty
//            collectionView.isHidden = trackers.isEmpty
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Трекеры"
        view.backgroundColor = .YPWhite
        addSubviews()
        makeConstraints()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "addTracker"),
            style: .plain,
            target: self,
            action:  #selector(didTapAddTarget)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.tintColor = .YPBlack
        
        guard let emptyImage = UIImage(named: "dizzy") else { return }
        emptyView.configureView(image: emptyImage, text: "Что будем отслежить?")
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
    
    @objc private func didTapAddTarget() {}
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}
