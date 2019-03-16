//
//  ViewController.swift
//  PinFish
//
//  Created by Banana Viking on 3/16/19.
//  Copyright © 2019 Banana Viking. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Alamofire
import SwiftyJSON

class PinLocationViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var lastGeocodingError: Error?
    var timer: Timer?
    var managedObjectContext: NSManagedObjectContext!
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    let appID = "63b1578537bf98519c346221f7f4efda"
//    let weatherData = WeatherData()
    var weatherString = "No weather data"
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var latitudeTextLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var longitudeTextLabel: UILabel!
    @IBOutlet weak var getLocationButton: UIButton!
    @IBOutlet weak var pinLocationButton: UIButton!
    
    @IBAction func getLocation(_ sender: UIButton) {
        let buttons = [getLocationButton, pinLocationButton]
        for button in buttons {
            button?.layer.cornerRadius = 4.5
            button?.layer.shadowColor = UIColor.black.cgColor
            button?.layer.shadowOffset = CGSize(width: 4.5, height: 4.5)
            button?.layer.shadowRadius = 4.5
            button?.layer.shadowOpacity = 0.75
        }
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            latitudeTextLabel.isHidden = false
            longitudeTextLabel.isHidden = false
            pinLocationButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            latitudeTextLabel.isHidden = true
            longitudeTextLabel.isHidden = true
            pinLocationButton.isHidden = true
            
            let statusMessage: String
            if lastLocationError as NSError? != nil {
                statusMessage = "Error Getting Location"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = ""
            }
            messageLabel.text = statusMessage
        }
        configureGetButton()
    }

    func configureGetButton() {
        let spinnerTag = 1000
        
        if updatingLocation {
            messageLabel.text = "Calculating nearest location..."
            getLocationButton.setTitle("Stop", for: .normal)
            
            if view.viewWithTag(spinnerTag) == nil {
                let spinner = UIActivityIndicatorView(style: .whiteLarge)
                spinner.center = messageLabel.center
                spinner.center.y = messageLabel.center.y + 40
                spinner.startAnimating()
                spinner.tag = spinnerTag
                view.addSubview(spinner)
            }
        } else {
            getLocationButton.setTitle("Get Location", for: .normal)
            
            if let spinner = view.viewWithTag(spinnerTag) {
                spinner.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinLocationSegue" {
//            let controller = segue.destination as! PinDetailsViewController
//            controller.coordinate = location!.coordinate
//            controller.weatherString = weatherString
//            controller.managedObjectContext = managedObjectContext
        }
    }
}

