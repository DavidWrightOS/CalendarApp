//
//  MonthViewController.swift
//  CalendarApp
//
//  Created by David Wright on 1/18/21.
//

import UIKit

class MonthViewController: UIViewController {
    
    // MARK: Views
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let numberOfMonthsInCollectionView = 100
    
    private var indexPathForCurrentDay: IndexPath?
    
    private var isInitialScrollComplete: Bool = false
    
    // MARK: Calendar Data Values
    
    private let selectedDate: Date
    
    private var baseDate: Date {
        didSet {
            daysByMonth = generateDaysInMonths(for: baseDate)
            collectionView.reloadData()
        }
    }
    
    private lazy var daysByMonth = generateDaysInMonths(for: baseDate)
    
    private var firstDayOfMonthForSection = [Date]()
    
    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
    private let calendar = Calendar(identifier: .gregorian)
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    // MARK: Initializers
    
    init(baseDate: Date = Date()) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        
        collectionView.register(MonthCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MonthCollectionViewHeader.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        daysByMonth = generateDaysInMonths(for: baseDate)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isInitialScrollComplete {
            isInitialScrollComplete = true
            
            // Need to call `collectionViewContentSize` in order to force the collectionView
            // to render its layout before scrolling to a particular section location
            let _ = collectionView.collectionViewLayout.collectionViewContentSize
            
            scrollToCurrentMonth(animated: false)
        }
    }
    
    // MARK: - Methods
    
    func scrollToCurrentMonth(animated: Bool) {
        guard let indexPathForCurrentDay = indexPathForCurrentDay else { return }
        
        let indexPath = IndexPath(item: 0, section: indexPathForCurrentDay.section)
        scrollToSection(indexPath.section, animated: animated)
    }
}

// MARK: - Day Generation

extension MonthViewController {
    
    private func getFirstDayOfMonth(for date: Date) -> Date {
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            preconditionFailure("An error occurred when generating the monthData for \(date)")
        }
        return firstDay
    }
    
    private func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count else {
            preconditionFailure("An error occurred when generating the monthData for \(baseDate)")
        }
        
        let firstDayOfMonth = getFirstDayOfMonth(for: baseDate)
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offsetInInitialRow = firstDayWeekday
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    private func generateDaysInMonths(for baseDate: Date) -> [[Day]] {
        var daysByMonth = Array(repeating: [Day](), count: numberOfMonthsInCollectionView)
        var firstDayOfMonthForSection = [Date]()
        
        let startMonth = -(numberOfMonthsInCollectionView - 1) / 2
        var date = calendar.date(byAdding: .month, value: startMonth, to: baseDate)!
        
        for i in 0..<numberOfMonthsInCollectionView {
            daysByMonth[i] = generateDaysInMonth(for: date)
            
            let firstDay = getFirstDayOfMonth(for: date)
            firstDayOfMonthForSection.append(firstDay)
            
            date = calendar.date(byAdding: .month, value: 1, to: date)!
        }
        
        let itemIndexForToday = calendar.component(.day, from: baseDate)
        let sectionIndexForToday = -startMonth
        
        self.indexPathForCurrentDay = IndexPath(item: itemIndexForToday, section: sectionIndexForToday)
        self.firstDayOfMonthForSection = firstDayOfMonthForSection
        
        return daysByMonth
    }
    
    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let number = dateFormatter.string(from: date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isWeekend = calendar.isDateInWeekend(date)
        
        // TODO: Set hasEvent based on actual Event data
        // Event indicators are set randomly for testing purposes; event indicator dates persist between runs
        let hasEvent = calendar.dateComponents([.day, .month, .year], from: date).hashValue % 6 == 0
        
        return Day(date: date, number: number, isSelected: isSelected, isWithinDisplayedMonth: isWithinDisplayedMonth, isWeekend: isWeekend, hasEvent: hasEvent)
    }
    
    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else { return [] }
        
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else { return [] }
        
        let days: [Day] = (1...additionalDays).map { generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false) }
        
        return days
    }
    
    private func selectedDateChanged(_ date: Date) {
        // TODO: Implement selectedDateChanged(_:)
    }
    
    private func scrollToSection(_ section: Int, animated: Bool)  {
        let indexPath = IndexPath(item: 0, section: section)
        
        if let attributes =  collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top)
            collectionView.setContentOffset(topOfHeader, animated: animated)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MonthViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        daysByMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        daysByMonth[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = daysByMonth[indexPath.section][indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reuseIdentifier, for: indexPath) as! DayCell
        
        cell.day = day
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MonthViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = daysByMonth[indexPath.section][indexPath.row]
        selectedDateChanged(day.date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        let width = collectionView.frame.width / 7
        let height: CGFloat = 72
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: MonthCollectionViewHeader.reuseIdentifier,
                                                                     for: indexPath) as! MonthCollectionViewHeader
        
        header.monthStartDate = firstDayOfMonthForSection[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 28)
    }
}
