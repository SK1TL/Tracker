//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Артур Гайфуллин on 06.04.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private enum Search {
        case text
        case weekDay
    }
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.tintColor = .YPBlack
        addButton.setImage(Resources.SfSymbols.addTracker, for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didTapAddTracker), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.sizeThatFits(CGSize(width: 77, height: 64))
        datePicker.backgroundColor = .YPLightGray
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.setDate(currentDate, animated: true)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.layer.cornerRadius = Resources.Dimensions.smallCornerRadius
        datePicker.layer.masksToBounds = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var searchBar: UISearchController = {
        let searchBar = UISearchController()
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.placeholder = Resources.Labels.searchBar

        searchBar.searchBar.searchTextField.clearButtonMode = .never
        return searchBar
    }()
    
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        return emptyView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(
            TrackerHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerID
        )
        collectionView.backgroundColor = .YPWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.scrollIndicatorInsets = UIEdgeInsets(
            top: Resources.Layouts.indicatorInset,
            left: Resources.Layouts.indicatorInset,
            bottom: Resources.Layouts.indicatorInset,
            right: Resources.Layouts.indicatorInset
        )
        return collectionView
    }()
    
    private lazy var safeArea: UILayoutGuide = {
        view.safeAreaLayoutGuide
    }()
    
    private let cellID = "cell"
    private let headerID = "header"
    private let trackerFactory = TrackersFactory.shared
    
    private var searchBarUserInput = ""
    private var visibleCategories: [TrackerCategory] = []
    private var weekDay = 0
    
    private var currentDate = Date() {
        didSet {
            weekDay = currentDate.weekDay()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .YPWhite
        currentDate = Date()
        searchBar.searchBar.delegate = self
        setupMockCategory()
        configureUI()
        updateTrackerCollectionView()
    }
    
    private func updateTrackerCollectionView() {
        if visibleCategories.isEmpty {
            makeEmptyViewForTrackers()
        } else {
            collectionView.isHidden = false
            emptyView.isHidden = true
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func fetchTracker(from tracker: Tracker, for categoryIndex: Int) {
        trackerFactory.addTracker(tracker, toCategory: categoryIndex)
        searchInTrackers()
//        fetchVisibleCategoriesFromFactory()
//        updateTrackerCollectionView()
    }
    
    private func fetchVisibleCategoriesFromFactory() {
        clearVisibleCategories()
        for eachCategory in trackerFactory.categories where !eachCategory.items.isEmpty {
            visibleCategories.append(eachCategory)
        }
        updateTrackerCollectionView()
    }
    
    private var calendar: Calendar = Calendar.current
    
    private var selectedWeekday: Int {
        calendar.component(.weekday, from: datePicker.date)
    }
    
    private func clearVisibleCategories() {
//        visibleCategories = []
    }
    
    private func searchInTrackers() {
        visibleCategories = trackerFactory.categories.map { category in
            let trackers = category.items.filter { tracker in
                let scheduleContains = tracker.schedule.contains { day in
                    return day.rawValue == selectedWeekday
                }
                return scheduleContains
            }
            return TrackerCategory(id: UUID(), name: category.name, items: trackers)
        }
        .filter {
            !$0.items.isEmpty
        }
//        print("visibleCategories", visibleCategories)
        updateTrackerCollectionView()
//        clearVisibleCategories()
//        for eachCategory in currentCategories {
//            var currentTrackers: [Tracker] = []
//            let trackers = eachCategory.items.count
//            for index in 0..<trackers {
//                let tracker = eachCategory.items[index]
//                switch type {
//                case .text:
//                    let tracker = eachCategory.items[index]
//                    if tracker.title.lowercased().contains(searchBarUserInput.lowercased()) {
//                        currentTrackers.append(tracker)
//                    }
//                case .weekDay:
//                    currentTrackers.append(tracker)
//                }
//            }
//            if !currentTrackers.isEmpty {
//                newCategories.append(
//                    TrackerCategory(
//                        id: eachCategory.id,
//                        name: eachCategory.name,
//                        items: currentTrackers
//                    )
//                )
//            }
//        }
//        visibleCategories = newCategories
//        if !visibleCategories.isEmpty {
//            makeEmptyViewForSearchBar()
//        }
//        updateTrackerCollectionView()
    }
    
    private func makeEmptyViewForTrackers() {
        guard let emptyTrackersImage = Resources.Images.emptyTrackers else { return }
        emptyView.configureView(image: emptyTrackersImage, text: Resources.Labels.emptyTracker)
        emptyView.isHidden = false
        collectionView.isHidden = true
    }
    
    private func makeEmptyViewForSearchBar() {
        guard let emptySearchImage = Resources.Images.emptySearch else { return }
        emptyView.configureView(image: emptySearchImage, text: Resources.Labels.emptySearch)
        emptyView.isHidden = false
        collectionView.isHidden = true
    }
    
    private func setupMockCategory() {
        trackerFactory.addNew(category: TrackerCategory(id: UUID(), name: "Важное", items: []))
        trackerFactory.addNew(category: TrackerCategory(id: UUID(), name: "Нужное", items: []))
    }
    
    @objc private func didTapAddTracker() {
        let nextController = NewTrackerViewController()
        nextController.modalPresentationStyle = .popover
        nextController.delegate = self
        navigationController?.present(nextController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        searchInTrackers()
        dismiss(animated: true)
    }
}

extension TrackerViewController {
    private func configureUI() {
        configureNavigationBarSection()
        configureCollectionView()
        configureEmptyView()
    }
    
    private func configureEmptyView() {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension TrackerViewController {
    //MARK: - Configure TabBarItemsView
    private func configureNavigationBarSection() {
        configureNavigationBarItems()
        addNavSubviews()
    }
    
    private func addNavSubviews() {
        view.addSubview(addButton)
        view.addSubview(datePicker)
    }
    
    private func configureNavigationBarItems() {
        guard
            let navigatorBar = navigationController?.navigationBar,
            let topItem = navigatorBar.topItem
        else { return }
        
        let addButtonItem = UIBarButtonItem(customView: addButton)
        let dateSelectionButton = UIBarButtonItem(customView: datePicker)
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigatorBar.prefersLargeTitles = true
        
        topItem.title = Resources.Labels.trackers
        topItem.titleView?.tintColor = .YPBlack
        topItem.searchController = searchBar
        topItem.setRightBarButton(dateSelectionButton, animated: true)
        topItem.setLeftBarButton(addButtonItem, animated: true)
    }
}

extension TrackerViewController {
    //MARK: - Configure TrackersCollectionView
    private func configureCollectionView() {
        addCollectionSubviews()
        makeCollectionViewConstraints()
    }
    
    private func addCollectionSubviews() {
        view.addSubview(collectionView)
    }
    
    private func makeCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TrackerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarUserInput = searchText
        if searchBarUserInput.count > 2 {
            makeEmptyViewForSearchBar()
            searchInTrackers()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        fetchVisibleCategoriesFromFactory()
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(visibleCategories.count)
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(visibleCategories[section].items.count)
        return visibleCategories[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellID,
                for: indexPath
            ) as? TrackerCell else { return UICollectionViewCell()}
        let currentTracker = visibleCategories[indexPath.section].items[indexPath.row]
        let counterSettings = trackerFactory.getCounter(with: currentTracker.id, on: currentDate)
        let totalCount = counterSettings.0
        let isCompleted = counterSettings.1
        cell.delegate = self
        cell.configureCell(
            bgColor: Resources.colors[currentTracker.color],
            emoji: Resources.emojis[currentTracker.emoji],
            title: currentTracker.title,
            counter: totalCount
        )
        cell.makeItDone(isCompleted)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = headerID
        default:
            id = ""
        }
        guard
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: id,
                for: indexPath
            )
                as? TrackerHeader else { return TrackerHeader() }
        view.titleLabel.text = visibleCategories.isEmpty ? "" : visibleCategories[indexPath.section].name
        return view
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: (
                collectionView.bounds.width - Resources.Layouts.spacingElement - 2 * Resources.Layouts.leadingElement
            ) / Resources.Layouts.trackersPerLine,
            height: Resources.Dimensions.trackerHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: Resources.Dimensions.sectionHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: .zero,
            left: Resources.Layouts.leadingElement,
            bottom: .zero,
            right: Resources.Layouts.leadingElement
        )
    }
}

extension TrackerViewController: NewTrackerViewControllerDelegate {
    func newTrackerViewController(
        _ viewController: NewTrackerViewController,
        didFilledTracker tracker: Tracker,
        for categoryIndex: Int
    ) {
        dismiss(animated: true) {
            [weak self] in
            guard let self else { return }
            self.fetchTracker(from: tracker, for: categoryIndex)
        }
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func trackerCellDidTapDone(for cell: TrackerCell) {
        guard
            Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedAscending
                || Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedSame
        else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = visibleCategories[indexPath.section].items[indexPath.row]
        let counter = trackerFactory.setTrackerDone(with: tracker.id, on: currentDate)
        cell.updateCounter(counter.0)
        cell.makeItDone(counter.1)
    }
}
