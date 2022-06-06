//
//  SearchController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/6.
//

import UIKit

class SearchViewController: UIViewController {
    private var searchNotesTableView = UITableView(frame: .zero)
    private var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func setupTableView() {
        
        self.searchNotesTableView.separatorColor = .clear
        searchNotesTableView.registerCellWithNib(identifier: String(describing: NoteResultTableViewCell.self), bundle: nil)
        searchNotesTableView.dataSource = self
        searchNotesTableView.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        searchNotesTableView.addGestureRecognizer(longPress)
        view.addSubview(searchNotesTableView)
        searchNotesTableView.translatesAutoresizingMaskIntoConstraints = false
        searchNotesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchNotesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchNotesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchNotesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    
}
