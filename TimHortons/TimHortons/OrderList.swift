//
//  ViewController.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-05.
//

import UIKit

// Main view controller for displaying and managing order items
class TimsViewController: UITableViewController, AddOrderViewControllerDelegate {
    var order: Name!

    // Called when the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never // Disable large titles for this view controller
        //title = order.name
        // Create and add some initial items to the list
        //loadOrder() // Load saved orders
    }

    // MARK: - Table View Data Source

    // Returns the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.orders.count
    }

    // Configures and returns a cell for a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "OrderItem",
            for: indexPath)

        let item = order.orders[indexPath.row]

        configureText(for: cell, with: item) // Set the cell's text
        configureCheckmark(for: cell, with: item) // Set the cell's checkmark
        return cell
    }

    // MARK: - Table View Delegate

    // Called when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = order.orders[indexPath.row]
            item.checked.toggle() // Toggle the item's checked status
            configureCheckmark(for: cell, with: item) // Update the checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row
        //saveOrder() // Save the updated order
    }
    
    // Called when a row is to be deleted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        order.orders.remove(at: indexPath.row) // Remove the item from the array

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Delete the row from the table view
        //saveOrder() // Save the updated order
    }

    // Configures the checkmark for a cell
    func configureCheckmark(for cell: UITableViewCell, with item: OrderItem) {
        let label = cell.viewWithTag(1001) as! UILabel

        if item.checked {
            label.text = "√" // Show checkmark if item is checked
        } else {
            label.text = "" // Hide checkmark if item is not checked
        }
    }

    // Configures the text for a cell
    func configureText(for cell: UITableViewCell, with item: OrderItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text // Set the cell's text to the item's text
    }

    // MARK: - Navigation

    // Prepare for segue to another view controller
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "AddOrder" {
            let controller = segue.destination as! AddOrderViewController
            controller.delegate = self // Set self as delegate for AddOrderViewController
        } else if segue.identifier == "EditOrder" {
            let controller = segue.destination as! AddOrderViewController
            controller.delegate = self // Set self as delegate for AddOrderViewController

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = order.orders[indexPath.row] // Pass the item to be edited to the next controller
            }
        }
    }
    
    // MARK: - Add Item ViewController Delegates

    // Called when a new item is added
    func AddOrderViewController(_ controller: AddOrderViewController, didFinishAdding item: OrderItem) {
        let newRowIndex = order.orders.count
        order.orders.append(item) // Add the new item to the array

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic) // Insert a new row for the item
        navigationController?.popViewController(animated: true) // Return to the previous screen
        //saveOrder() // Save the updated order
    }

    // Called when an item is edited
    func AddOrderViewController(_ controller: AddOrderViewController, didFinishEditing item: OrderItem) {
        if let index = order.orders.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item) // Update the cell's text
            }
        }
        navigationController?.popViewController(animated: true) // Return to the previous screen
        //saveOrder() // Save the updated order
    }
    
    // Called when the user cancels adding or editing an item
    func AddOrderViewControllerDidCancel(_ controller: AddOrderViewController) {
        navigationController?.popViewController(animated: true) // Return to the previous screen
    }
    
    // Returns the URL to the documents directory
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(
//            for: .documentDirectory,
//            in: .userDomainMask)
//        return paths[0]
//    }

    // Returns the file path for storing orders
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Orders.plist")
//    }
    
    // Saves the current order to a file
//    func saveOrder() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(order.orders)
//            try data.write(
//                to: dataFilePath(),
//                options: Data.WritingOptions.atomic)
//        } catch {
//            print("Error encoding item array: \(error.localizedDescription)")
//        }
//    }

    // Loads the order from a file
//    func loadOrder() {
//        let path = dataFilePath()
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                order.orders = try decoder.decode(
//                    [OrderItem].self,
//                    from: data)
//            } catch {
//                print("Error decoding item array: \(error.localizedDescription)")
//            }
//        }
//    }
}
