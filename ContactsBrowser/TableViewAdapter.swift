//
//  TableViewAdaptor.swift
//
//  Created by Paul Ossenbruggen on 5/25/17.


import UIKit


protocol TableViewDataManagerDelegate : class {
    func update()
}

protocol TableSectionAdaptor {
    var cellReuseIdentifier: String { get }
    var title: String { get }
    var height : CGFloat { get }
    var itemCount : Int { get }
    func select(index: Int)
    func configure(cell: UITableViewCell, index: Int)
}

class TableViewAdaptorSection<Cell, Model> : TableSectionAdaptor {
    internal let cellReuseIdentifier: String
    internal let title: String
    internal let height: CGFloat
    internal var items: [Model]
    
    init(cellReuseIdentifier : String,
         sectionTitle: String,
         height: CGFloat,
         items: [Model],
         select: @escaping ( Model ) -> Void,
         configure: @escaping (Cell, Model) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.title = sectionTitle
        self.height = height
        self.items = items
        self.configure = configure
        self.select = select
    }
    
    internal var itemCount: Int {
        return items.count
    }
    
    internal func select(index: Int) {
        select( items[index] )
    }
    
    internal func configure(cell: UITableViewCell, index: Int) {
        configure(cell as! Cell, items[index]) // if this fails check IB cell is correct type, or reuse identifier is registeed.
    }
    
    var configure: ( Cell, Model ) -> Void
    var select: ( Model ) -> Void
}


class TableViewAdaptor: NSObject, UITableViewDataSource, UITableViewDelegate, TableViewDataManagerDelegate {
    private let tableView: UITableView
    private let didChangeHandler: () -> Void
    let sections : [TableSectionAdaptor]
    
    init(tableView: UITableView,
         sections: [TableSectionAdaptor],
         didChangeHandler: @escaping () -> Void) {
        self.tableView = tableView
        self.didChangeHandler = didChangeHandler
        self.sections = sections
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:section.cellReuseIdentifier, for: indexPath)
        section.configure(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? 20 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? 20 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].select(index: indexPath.row)
    }
    
    func update() {
        DispatchQueue.main.async {
            self.didChangeHandler()
        }
    }
}
