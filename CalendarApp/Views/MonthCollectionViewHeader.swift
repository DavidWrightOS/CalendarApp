//
//  MonthCollectionViewHeader.swift
//  CalendarApp
//
//  Created by David Wright on 1/19/21.
//

import UIKit

class MonthCollectionViewHeader: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: MonthCollectionViewHeader.self)
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    var monthStartDate: Date? {
        didSet {
            updateViews()
        }
    }
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViews()
    }
}

// MARK: - Configure & Update Views

extension MonthCollectionViewHeader {
    
    private func configure() {
        addSubview(monthLabel)
        monthLabel.anchor(bottom: bottomAnchor)
    }
    
    private func updateViews() {
        guard let date = monthStartDate else { return }
        
        let weekday = Calendar.current.component(.weekday, from: date)
        let cellWidth = frame.width / 7
        let centerX = (CGFloat(weekday) - 0.5) * cellWidth
        
        monthLabel.center.x = centerX
        monthLabel.text = MonthCollectionViewHeader.monthFormatter.string(from: date)
        
        let isCurrentMonth = Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
        
        monthLabel.textColor = isCurrentMonth ? .systemRed : .label
    }
}
