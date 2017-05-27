//
//  ContactTableViewCell.swift
//
//  Created by Paul Ossenbruggen on 5/26/17.
//
//

import UIKit
import Contacts

class ContactTableViewCell: UITableViewCell {
    
    var title : String = ""
    var organization : String = ""
    var cellReuseIdentifier: String = ""
    var items: [Any] = []
    var height : CGFloat = 44.0
    var configure: (_ cell: Any, _ model: Any, _ index: Int) -> Void = {cell, model, index in }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle,  reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    struct ViewData {
        let title: String
        let organization : String
        let image : UIImage
    }
    
    var viewData: ViewData? {
        didSet {
            guard let viewData = viewData else {
                return
            }
            // if there is no name use the organization name, if both are 
            // present set the detail on the cell.
            let title = viewData.title.trimmingCharacters(in: .whitespaces)
            textLabel!.text = title != "" ? title : viewData.organization
            detailTextLabel!.text = title != "" ? viewData.organization : ""
            imageView!.image = viewData.image
        }
    }
    
    func configure(model: Any) {
        let model = model as! CNContact
        viewData = ViewData(model: model)
    }
}

extension ContactTableViewCell.ViewData {
    init(model: CNContact) {
        self.title = "\(model.givenName) \(model.familyName)"
        self.organization = model.organizationName
        if let data = model.thumbnailImageData, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = UIImage(named: "Placeholder")!
        }
    }
}

