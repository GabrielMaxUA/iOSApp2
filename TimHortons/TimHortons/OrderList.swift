//
//  ViewController.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-05.
//

import UIKit

// Main view controller for displaying and managing order items
class TimsViewController: UITableViewController, AddOrderViewControllerDelegate {
   
    var items = [OrderItem]() // Array to store order items

    // Called when the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true // Enable large titles
        
        // Create and add some initial items to the list
        let item1 = OrderItem()
        item1.text = "Double-Double"
        items.append(item1)

        let item2 = OrderItem()
        item2.text = "Dark Roast"
        item2.checked = true
        items.append(item2)

        let item3 = OrderItem()
        item3.text = "Donut"
        item3.checked = true
        items.append(item3)

        let item4 = OrderItem()
        item4.text = "Wrap"
        items.append(item4)
    }

    // MARK: - Table View Data Source

    // Returns the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // Configures and returns a cell for a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "OrderItem",
            for: indexPath)

        let item = items[indexPath.row]

        configureText(for: cell, with: item) // Set the cell's text
        configureCheckmark(for: cell, with: item) // Set the cell's checkmark
        return cell
    }

    // MARK: - Table View Delegate

    // Called when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle() // Toggle the item's checked status
            configureCheckmark(for: cell, with: item) // Update the checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row
    }
    
    // Called when a row is to be deleted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) // Remove the item from the array

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Delete the row from the table view
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
                controller.itemToEdit = items[indexPath.row] // Pass the item to be edited to the next controller
            }
        }
    }
    
    // MARK: - Add Item ViewController Delegates

    // Called when a new item is added
    func AddOrderViewController(_ controller: AddOrderViewController, didFinishAdding item: OrderItem) {
        let newRowIndex = items.count
        items.append(item) // Add the new item to the array

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic) // Insert a new row for the item
        navigationController?.popViewController(animated: true) // Return to the previous screen
    }

    // Called when an item is edited
    func AddOrderViewController(_ controller: AddOrderViewController, didFinishEditing item: OrderItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item) // Update the cell's text
            }
        }
        navigationController?.popViewController(animated: true) // Return to the previous screen
    }
    
    // Called when the user cancels adding or editing an item
    func AddOrderViewControllerDidCancel(_ controller: AddOrderViewController) {
        navigationController?.popViewController(animated: true) // Return to the previous screen
    }
}
