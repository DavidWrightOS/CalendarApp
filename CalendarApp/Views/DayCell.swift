//
//  DayCell.swift
//  CalendarApp
//
//  Created by David Wright on 1/17/21.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: DayCell.self)
    
    var day: Day? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var eventIndicatorView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        let config = UIImage.SymbolConfiguration(pointSize: 8.5)
        view.image = UIImage(systemName: "circle.fill", withConfiguration: config)?
            .withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Views

extension DayCell {
    
    private func configure() {
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(eventIndicatorView)
        
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor.opaqueSeparator
        topBorder.setDimensions(height: 0.2)
        contentView.addSubview(topBorder)
        topBorder.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
        
        let selectionBGDiameter: CGFloat = 36
        selectionBackgroundView.layer.cornerRadius = selectionBGDiameter / 2
        selectionBackgroundView.anchor(top: contentView.topAnchor, paddingTop: 5)
        selectionBackgroundView.centerX(inView: contentView)
        selectionBackgroundView.setDimensions(height: selectionBGDiameter, width: selectionBGDiameter)
        
        numberLabel.centerX(inView: selectionBackgroundView)
        numberLabel.centerY(inView: selectionBackgroundView)
        
        eventIndicatorView.centerX(inView: selectionBackgroundView)
        eventIndicatorView.anchor(top: selectionBackgroundView.bottomAnchor, paddingTop: 2)
    }
}

// MARK: - Appearance

extension DayCell {
    
    private func updateViews() {
        guard let day = day else { return }
        
        guard day.isWithinDisplayedMonth else {
            isUserInteractionEnabled = false
            contentView.isHidden = true
            return
        }
        
        isUserInteractionEnabled = true
        contentView.isHidden = false
        eventIndicatorView.isHidden = !day.hasEvent
        numberLabel.text = day.number
        updateSelectionStatus()
    }
    
    private func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isWeekend: day.isWeekend)
        }
    }
    
    private func applySelectedStyle() {
        numberLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        numberLabel.textColor = .white
        selectionBackgroundView.isHidden = false
    }
    
    private func applyDefaultStyle(isWeekend: Bool) {
        numberLabel.font = .systemFont(ofSize: 19, weight: .regular)
        numberLabel.textColor = isWeekend ? .secondaryLabel : .label
        selectionBackgroundView.isHidden = true
    }
}
