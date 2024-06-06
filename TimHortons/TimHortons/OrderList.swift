//
//  ViewController.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-05.
//

import UIKit

class TimsViewController: UITableViewController, AddOrderViewControllerDelegate {
   
    var items = [OrderItem]()

    override func viewDidLoad() {
      super.viewDidLoad()
        
      navigationController?.navigationBar.prefersLargeTitles = true
      // Replace previous code with the following
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "OrderItem",
        for: indexPath)

      let item = items[indexPath.row]

      configureText(for: cell, with: item)
      configureCheckmark(for: cell, with: item)
      return cell
    }


    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let cell = tableView.cellForRow(at: indexPath) {
        let item = items[indexPath.row]
        item.checked.toggle()
        configureCheckmark(for: cell, with: item)
      }
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      // 1
      items.remove(at: indexPath.row)

      // 2
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }


    func configureCheckmark(for cell: UITableViewCell, with item: OrderItem) {
      let label = cell.viewWithTag(1001) as! UILabel

      if item.checked {
        label.text = "√"
      } else {
        label.text = ""
      }
    }


    func configureText(for cell: UITableViewCell, with item: OrderItem) {
      let label = cell.viewWithTag(1000) as! UILabel
      label.text = item.text
    }

    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      // 1
      if segue.identifier == "AddOrder" {
        // 2
        let controller = segue.destination as! AddOrderViewController
        // 3
        controller.delegate = self
      }
        else if segue.identifier == "EditOrder" {
          let controller = segue.destination as! AddOrderViewController
          controller.delegate = self

            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
                }
            }
        }
    
    func AddOrderViewController(_ controller: AddOrderViewController, didFinishAdding item: OrderItem) {
      let newRowIndex = items.count
      items.append(item)

      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      navigationController?.popViewController(animated:true)
    }

    func AddOrderViewController(_ controller: AddOrderViewController,didFinishEditing item: OrderItem) {
      if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Add Item ViewController Delegates
    func AddOrderViewControllerDidCancel(_ controller: AddOrderViewController) {
      navigationController?.popViewController(animated: true)
    }
}

