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
            
    private let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        
        let viewStyleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(viewStyleButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        let navItem = UINavigationItem()
        
        let backButton: UIButton = {
            let button = UIButton(type: .system)
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            let currentMonth = monthFormatter.string(from: Date())
            button.setTitle(" " + currentMonth, for: .normal)
            
            let config = UIImage.SymbolConfiguration(textStyle: UIFont.TextStyle.headline, scale: .large)
            let backImage = UIImage(systemName: "chevron.backward")?.withConfiguration(config)
            button.setImage(backImage, for: .normal)
            
            button.setTitleColor(button.tintColor, for: .normal)
            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
            return button
        }()
        
        navItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navItem.rightBarButtonItems = [addButton, searchButton, viewStyleButton]
        navBar.setItems([navItem], animated: false)
        navBar.barTintColor = .barBackgroundColor
        navBar.isTranslucent = false
        
        return navBar
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .barBackgroundColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(navigationBar)
        navigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(toolbar)
        toolbar.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        view.insertSubview(headerView, at: 0)
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: navigationBar.bottomAnchor, right: view.rightAnchor)
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
        print("DEBUG: debug searchButtonTapped..")
    }
    
    @objc private func addButtonTapped() {
        print("DEBUG: debug addButtonTapped..")
    }
}
