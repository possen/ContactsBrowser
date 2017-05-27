import XCTest

@testable import ContactsBrowserLib

class ContactsTests: XCTestCase {
    
    func testGetContacts() {
        let exp = expectation(description: "getcontacts")
        ContactManager().contacts(search: "Appleseed") { contacts in
            XCTAssertTrue( contacts.count > 0)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 50)
    }
}
