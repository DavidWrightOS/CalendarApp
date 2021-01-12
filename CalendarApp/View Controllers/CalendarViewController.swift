//
//  CalendarViewController.swift
//  CalendarApp
//
//  Created by David Wright on 1/9/21.
//

import UIKit

class CalendarViewController: UIViewController {
    
    private let toolbar: UIToolbar = {
        let tb = UIToolbar()
        let barButtonItems: [UIBarButtonItem] = [
            UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonTapped)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Calendars", style: .plain, target: self, action: #selector(calendarsButtonTapped)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Inbox", style: .plain, target: self, action: #selector(inboxButtonTapped))
        ]
        tb.setItems(barButtonItems, animated: false)
        return tb
    }()
            
    lazy private var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        
        let viewStyleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(viewStyleButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        let backButton: UIButton = {
            let button = UIButton(type: .system)
            let currentMonth = monthFormatter.string(from: Date())
            
            button.setTitle(" " + currentMonth, for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            button.setTitleColor(button.tintColor, for: .normal)
            
            let config = UIImage.SymbolConfiguration(textStyle: UIFont.TextStyle.headline, scale: .large)
            let backImage = UIImage(systemName: "chevron.backward")?.withConfiguration(config)
            button.setImage(backImage, for: .normal)
            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            return button
        }()
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navItem.rightBarButtonItems = [addButton, searchButton, viewStyleButton]
        navBar.setItems([navItem], animated: false)
        navBar.delegate = self
        
        return navBar
    }()
    
    private lazy var searchNavigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem()
        navItem.titleView = searchBar
        navBar.setItems([navItem], animated: false)
        navBar.delegate = self
        return navBar
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.tintColor = .systemRed
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var searchNavigationBarTopAnchor: NSLayoutConstraint = {
        NSLayoutConstraint(item: searchNavigationBar,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view.safeAreaLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0)
    }()
    
    private lazy var searchNavigationBarBottomAnchor: NSLayoutConstraint = {
        NSLayoutConstraint(item: searchNavigationBar,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0)
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .barBackgroundColor
        
        let headerBottomBorder = UIView()
        headerBottomBorder.backgroundColor = .separator
        headerBottomBorder.setDimensions(height: 0.2)
        view.addSubview(headerBottomBorder)
        headerBottomBorder.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(dayOfWeekStackView)
        dayOfWeekStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 1, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(dateTitleLabel)
        dateTitleLabel.anchor(top: dayOfWeekStackView.bottomAnchor, left: view.leftAnchor, bottom: headerBottomBorder.topAnchor, right: view.rightAnchor, paddingBottom: 12)
        
        return view
    }()
    
    lazy private var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.text = dateTitleFormatter.string(from: Date())
        return label
    }()
    
    lazy private var dayOfWeekStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        let dayOfWeekLetters = ["S", "M", "T", "W", "T", "F", "S"]
        let buttonSpacingWidth = stack.spacing * CGFloat(dayOfWeekLetters.count + 1)
        let buttonWidth = (UIScreen.main.bounds.width - buttonSpacingWidth) / CGFloat(dayOfWeekLetters.count)
        
        for i in dayOfWeekLetters.indices {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .preferredFont(forTextStyle: .caption2)
            label.textColor = dayOfWeekLetters[i] == "S" ? .secondaryLabel : .label
            label.text = dayOfWeekLetters[i]
            
            let button = dayOfWeekButtons[i]
            let dayStackView = UIStackView(arrangedSubviews: [label, button])
            dayStackView.axis = .vertical
            stack.addArrangedSubview(dayStackView)
        }
        
        return stack
    }()
    
    private let dayOfWeekButtons: [UIButton] = {
        var buttons = [UIButton]()
        
        let date = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .weekday], from: date)
        let dayOfWeek = dateComponents.day!
        let weekDay = dateComponents.weekday!
        
        for i in 1...7 {
            let daysFromToday = i - weekDay
            let buttonDayOfWeek = dayOfWeek.advanced(by: daysFromToday)
            
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.imageView?.contentMode = .scaleAspectFit
            button.titleLabel?.font = .systemFont(ofSize: 19, weight: .medium)
            button.setTitle(String(buttonDayOfWeek), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(dayOfWeekTapped), for: .touchUpInside)
            button.setBackgroundImage(nil, for: .normal)
            
            if i == weekDay {
                button.setBackgroundImage(UIImage(systemName: "circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .selected)
                button.setTitleColor(.systemRed, for: .normal)
                button.setTitleColor(.label, for: .selected)
                button.isSelected = true
            } else {
                button.setBackgroundImage(UIImage(systemName: "circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
                button.setTitleColor(.barBackgroundColor, for: .selected)
                if i == 1 || i == 7 {
                    button.setTitleColor(.secondaryLabel, for: .normal)
                } else {
                    button.setTitleColor(.label, for: .normal)
                }
            }
            
            buttons.append(button)
        }
        
        return buttons
    }()
    
    private var currentDate: Date { Date() }
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private let dayNumberFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let dateTitleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE  MMMM d, yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(navigationBar)
        navigationBar.sizeToFit()
        navigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(toolbar)
        toolbar.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(headerView)
        headerView.anchor(top: navigationBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: -1)
        
        view.addSubview(searchNavigationBar)
        searchNavigationBar.anchor(left: view.leftAnchor, right: view.rightAnchor)
        searchNavigationBarTopAnchor.isActive = false
        searchNavigationBarBottomAnchor.isActive = true
    }
    
    // MARK: - Selectors
    
    @objc private func todayButtonTapped() {
        print("DEBUG: debug todayButtonTapped..")
    }
    
    @objc private func calendarsButtonTapped() {
        print("DEBUG: debug calendarsButtonTapped..")
    }
    
    @objc private func inboxButtonTapped() {
        print("DEBUG: debug inboxButtonTapped..")
    }
    
    @objc private func backButtonTapped() {
        print("DEBUG: debug backButtonTapped..")
    }
    
    @objc private func viewStyleButtonTapped() {
        print("DEBUG: debug viewStyleButtonTapped..")
    }
    
    @objc private func searchButtonTapped() {
        showSearchBar()
    }
    
    @objc private func addButtonTapped() {
        print("DEBUG: debug addButtonTapped..")
    }
    
    @objc private func dayOfWeekTapped(sender: UIButton) {
        if let selectedButton = dayOfWeekButtons.first(where: { $0.isSelected == true }), selectedButton.tag != sender.tag {
            selectedButton.isSelected = false
        }
        
        sender.isSelected = true
            
        let date = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .weekday], from: date)
        let weekDay = dateComponents.weekday!
        let dayOffest = sender.tag - weekDay
        let selectedDate = calendar.date(byAdding: .day, value: dayOffest, to: date)!
        dateTitleLabel.text = dateTitleFormatter.string(from: selectedDate)
    }
}


// MARK: - Navigation Bar Delegate

extension CalendarViewController: UINavigationBarDelegate, UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


// MARK: - UISearch Bar Delegate

extension CalendarViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func showSearchBar() {
        searchBar.isHidden = false
        searchBar.becomeFirstResponder()
        searchNavigationBarTopAnchor.isActive = true
        searchNavigationBarBottomAnchor.isActive = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in }
    }
    
    func hideSearchBar() {
        searchBar.resignFirstResponder()
        searchNavigationBarTopAnchor.isActive = false
        searchNavigationBarBottomAnchor.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { finished in
            self.searchBar.isHidden = true
        }
    }
}
