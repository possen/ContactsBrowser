//
//  DetailViewController.swift
//  ContactsBrowser
//
//  Created by Paul Ossenbruggen on 5/25/17.
//
//

import UIKit
import Contacts
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
    let model: CNContact
    var map : MKMapView? = nil
    
    init(model: CNContact) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = UIColor.white
        map = MKMapView(frame: self.view.frame)
        
        
        // create the placemarks
        for postalAddress in model.postalAddresses {
            let address = postalAddress.value
            let addressStr = "\(address.street) \(address.city) \(address.state) \(address.postalCode) \(address.country)"
            addressToCoordinatesConverter(address: addressStr)
        }
        view.addSubview(map!)
    }
    
    func addressToCoordinatesConverter(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if let error = error {
                print(address, error)
            } else {
                if let placemarks = placemarks {
                    for placemark in placemarks {
                        let pm = MKPlacemark(placemark: placemark)
                        self.map?.addAnnotation(pm)
                    }
                }
            }
        })
    }
}
