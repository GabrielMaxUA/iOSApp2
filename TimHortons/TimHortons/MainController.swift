//
//  MainController.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-13.
//

import UIKit
import MapKit
import CoreLocation

class MainController: UITableViewController, CLLocationManagerDelegate, NameEditDelegate {
    
    @IBOutlet weak var findCoffeeShopButton: UIButton!
    
    let locationManager = CLLocationManager()
    let coffeeShopLocation = CLLocationCoordinate2D(latitude: 43.6900516, longitude: -79.3248001)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        // Load data
        loadNames()
        
        locationManager.delegate = self
    }

    @IBAction func findCoffeeShopTapped(_ sender: UIButton) {
        print("Button tapped")
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            openMapWithCoffeeShopLocation()
        @unknown default:
            fatalError("Unhandled case in location authorization status")
            break
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func openMapWithCoffeeShopLocation() {
        
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(center: coffeeShopLocation, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coffeeShopLocation, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Tim Hortons"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func showLocationDeniedAlert() {
        let alert = UIAlertController(title: "Location Access Denied", message: "Location access is required to find nearby coffee shops. Please enable location services in settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        print("Location access denied alert shown")
    }

    // MARK: - Name Edit View Controller Delegates
    
    // Delegate method called when the user cancels name editing
    func nameEditDidCancel(_ controller: NameEdit) {
        navigationController?.popViewController(animated: true)
    }

    // Delegate method called when the user finishes adding a new name
    func nameEdit(_ controller: NameEdit, didFinishAdding name: Name) {
        let newRowIndex = lists.count
        lists.append(name)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)

        navigationController?.popViewController(animated: true)
    }

    // Delegate method called when the user finishes editing an existing name
    func nameEdit(_ controller: NameEdit, didFinishEditing name: Name) {
        if let index = lists.firstIndex(of: name) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = name.name
            }
        }
        navigationController?.popViewController(animated: true)
    }

    let cellIdentifier = "OrderCell"
    var lists = [Name]()

    // MARK: - Table view data source
    
    // Returns the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    // Called to commit the insertion or deletion of a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row) // Remove the item from the array

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Delete the row from the table view
    }
    
    // Configures and returns the cell for a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let order = lists[indexPath.row]
        cell.textLabel!.text = order.name
        cell.accessoryType = .detailDisclosureButton

        return cell
    }

    // Called when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = lists[indexPath.row]
        performSegue(withIdentifier: "ShowOrders", sender: order)
    }

    // MARK: - Navigation
    
    // Prepares for segue to another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOrders" {
            let controller = segue.destination as! TimsViewController
            controller.order = sender as? Name
        } else if segue.identifier == "AddName" {
            let controller = segue.destination as! NameEdit
            controller.delegate = self
        } else if segue.identifier == "EditName" {
            let controller = segue.destination as! NameEdit
            controller.delegate = self

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.nameToEdit = lists[indexPath.row]
            }
        }
    }
    
    // Called when the accessory button is tapped
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddName") as! NameEdit
        controller.delegate = self

        let name = lists[indexPath.row]
        controller.nameToEdit = name

        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Data Saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Orders.plist")
    }

    // this method is now called saveChecklists()
    func saveNames() {
        let encoder = PropertyListEncoder()
        do {
            // You encode lists instead of "items"
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }

    // this method is now called loadChecklists()
    func loadNames() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                // You decode to an object of [Checklist] type to lists
                lists = try decoder.decode([Name].self, from: data)
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
}
