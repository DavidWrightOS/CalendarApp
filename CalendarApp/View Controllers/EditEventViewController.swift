//
//  EditEventViewController.swift
//  CalendarApp
//
//  Created by David Wright on 1/12/21.
//

import UIKit

class EditEventViewController: UIViewController {
    
    // MARK: - Properties
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
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
        navigationItem.title = "New Event"
        configureTableView()
    }
}


// MARK: - Configure Table View

extension EditEventViewController {
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
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
