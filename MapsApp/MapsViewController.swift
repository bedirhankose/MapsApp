//
//  ViewController.swift
//  MapsApp
//
//  Created by Bedirhan Köse on 29.12.22.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var noteTF: UITextField!
    
    var locationManager = CLLocationManager()
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectLocation(gestureRecognizer : UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: mapView)
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
            
            selectedLatitude = touchedCoordinate.latitude
            selectedLongitude = touchedCoordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            annotation.title = nameTF.text
            annotation.subtitle = noteTF.text
            mapView.addAnnotation(annotation)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations[0].coordinate.latitude)
        //print(locations[0].coordinate.longitude)
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context)
        
        newPlace.setValue(nameTF.text, forKey: "name")
        newPlace.setValue(noteTF.text, forKey: "note")
        newPlace.setValue(selectedLatitude, forKey: "latitude")
        newPlace.setValue(selectedLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Saved...")
        } catch {
            print("Error...")
        }
    }
    


}

