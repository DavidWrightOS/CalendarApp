//
//  EditEventViewController.swift
//  CalendarApp
//
//  Created by David Wright on 1/12/21.
//

import UIKit

class EditEventViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var dataSource: UITableViewDiffableDataSource<Int, Item>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Item>! = nil
    
    private var isAllDayEvent = false
    
    // TableView items by section
    
    private var itemsBySection: [[Item]] = {
        [
            [   // Section 0
                Item(type: .textField, placeholder: "Title"),
                Item(type: .location, placeholder: "Location")
            ],
            [   // Section 1
                Item(type: .allDaySwitch, text: "All-day"),
                Item(type: .date, text: "Starts", placeholder: "None"),
                Item(type: .date, text: "Ends", placeholder: "None"),
                Item(type: .repeats, text: "Repeat", placeholder: "Never"),
                Item(type: .travelTime, text: "Travel Time", placeholder: "None")
            ],
            [   // Section 2
                Item(type: .alert, text: "Alert", placeholder: "None")
            ],
            [   // Section 3
                Item(type: .attachment, text: "Add attachment...")
            ],
            [   // Section 4
                Item(type: .textField, placeholder: "URL"),
                Item(type: .textView, placeholder: "Notes")
            ]
        ]
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureDataSource()
        updateUI(animated: false)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EditEventViewController.Item.reuseIdentifier)
    }
    
    // MARK: - Selectors
    
    @objc private func didToggleAllDaySwitch(_ allDaySwitch: UISwitch) {
        isAllDayEvent = allDaySwitch.isOn
        updateUI()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped() {
        print("DEBUG: doneButtonTapped..")
    }
}


// MARK: - Update UI

extension EditEventViewController {
    
    func updateUI(animated: Bool = true) {
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        
        let sections = Array(0..<itemsBySection.count)
        currentSnapshot.appendSections(sections)
        
        for section in sections {
            let items = itemsBySection[section].filter { !($0.type == .travelTime && isAllDayEvent) }
            currentSnapshot.appendItems(items, toSection: section)
        }
        
        self.dataSource.apply(currentSnapshot, animatingDifferences: animated)
    }
}


// MARK: - Configure Navigation Bar

extension EditEventViewController {
    
    private func configureNavigationBar() {
        navigationItem.title = "New Event"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}


// MARK: - Configure Table View

extension EditEventViewController {
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}


// MARK: - Configure Data Source

extension EditEventViewController {
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Item>(tableView: tableView) {
            [weak self] (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            
            guard let self = self else { return nil }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: EditEventViewController.Item.reuseIdentifier, for: indexPath)
            var content: UIListContentConfiguration
            
            switch item.type {
            
            case .textField:
                content = cell.defaultContentConfiguration()
                content.text = item.text ?? item.placeholder
                content.textProperties.color = item.text == nil ? .placeholderText : .label
                content.secondaryText = nil
                cell.accessoryType = .none
                cell.accessoryView = nil
                
            case .location:
                content = UIListContentConfiguration.subtitleCell()
                content.text = item.text ?? item.placeholder
                content.textProperties.color = item.text == nil ? .placeholderText : .label
                content.secondaryText = item.detailText
                content.secondaryTextProperties.color = .label
                
            case .repeats, .travelTime, .alert:
                content = UIListContentConfiguration.valueCell()
                content.text = item.text
                content.textProperties.color = .label
                content.secondaryText = item.detailText ?? item.placeholder
                content.secondaryTextProperties.color = .secondaryLabel
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = nil
                
            case .allDaySwitch:
                content = cell.defaultContentConfiguration()
                content.text = item.text
                let allDaySwitch = UISwitch()
                allDaySwitch.isOn = self.isAllDayEvent
                allDaySwitch.isOn = false
                allDaySwitch.addTarget(self, action: #selector(self.didToggleAllDaySwitch(_:)), for: .touchUpInside)
                cell.accessoryView = allDaySwitch
                
            case .date:
                content = UIListContentConfiguration.valueCell()
                content.text = item.text
                content.textProperties.color = .label
                content.secondaryText = item.detailText ?? item.placeholder
                content.secondaryTextProperties.color = .secondaryLabel
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = nil
                
            case .attachment:
                content = UIListContentConfiguration.valueCell()
                content.text = item.text
                content.textProperties.color = .label
                content.secondaryText = nil
                cell.accessoryType = .none
                cell.accessoryView = nil
                
            case .textView:
                content = cell.defaultContentConfiguration()
                content.text = item.text ?? item.placeholder
                content.textProperties.color = item.text == nil ? .placeholderText : .label
                content.secondaryText = nil
                cell.accessoryType = .none
                cell.accessoryView = nil
            }
            
            cell.contentConfiguration = content
            return cell
        }
        
        self.dataSource.defaultRowAnimation = .fade
    }
}


// MARK: - Table View Delegate

extension EditEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Date Formatter

extension EditEventViewController {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
