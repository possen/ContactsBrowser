//
//  ContactsViewController.swift
//
//  Created by Paul Ossenbruggen on 5/26/17.
//
//

import UIKit
import Contacts
import ContactsBrowserLib

class ContactsViewController: UIViewController {
    var tableView : UITableView!
    var tableViewAdaptor : TableViewAdaptor? = nil
    var contactsManager = ContactManager()
    var searchView = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.frame)
        view.addSubview(tableView)
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactTypeCell")
        view = tableView
        
        setupSearchBar()
        
        title = "Contacts"
        let contactSection = TableViewAdaptorSection<ContactTableViewCell, CNContact> (
            cellReuseIdentifier: "ContactTypeCell",
            sectionTitle: "",
            height: 44,
            items: [],
            select: { model in self.select(model: model) })
        { cell, model in
            cell.viewData = ContactTableViewCell.ViewData(model: model)
        }
        
        tableViewAdaptor = TableViewAdaptor(
            tableView: tableView,
            sections: [contactSection],
            didChangeHandler: {
                self.tableView.reloadData()
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doSearch(text: "")
    }

    func select(model: CNContact) {
        let detailViewController = DetailViewController(model: model)
        
        _ = detailViewController.view
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ContactsViewController : UISearchBarDelegate {
    
    func setupSearchBar() {
        var searchFrame = view.frame
        searchFrame.size.height = 44
        
        let searchView = UISearchBar(frame: searchFrame)
        searchView.delegate = self
        tableView.tableHeaderView = searchView
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch(text: searchText)
    }
    
    func doSearch(text: String) {
        self.contactsManager.contacts(search: text) { contacts in
            let section = self.tableViewAdaptor!.sections[0] as! TableViewAdaptorSection<ContactTableViewCell, CNContact>
            section.items = contacts
            self.tableViewAdaptor?.update()
        }
    }
}



