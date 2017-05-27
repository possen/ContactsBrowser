//
//  ContactManager.swift
//
//  Created by Paul Ossenbruggen on 5/26/17.
//
//


import Foundation
import Contacts

open class ContactManager {
    let store = CNContactStore()

    public init() {
    }
    
    open func contacts(search: String, completion: @escaping ([CNContact]) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let keys = [CNContactGivenNameKey,
                            CNContactFamilyNameKey,
                            CNContactThumbnailImageDataKey,
                            CNContactPostalAddressesKey,
                            CNContactOrganizationNameKey]
                    as [CNKeyDescriptor]

                if search == "" {
                    let contacts = try self.store.unifiedContacts(matching:
                        CNContact.predicateForContactsInContainer(withIdentifier: self.store.defaultContainerIdentifier()), keysToFetch:keys)
                   
                    completion(contacts)
                } else {
                    
                    let contacts = try self.store.unifiedContacts(matching:
                        CNContact.predicateForContacts(matchingName: search), keysToFetch:keys)
                    
                    completion(contacts)
                }
            } catch let error {
                print(error)
                completion([])
            }
        }
    }
}
