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
