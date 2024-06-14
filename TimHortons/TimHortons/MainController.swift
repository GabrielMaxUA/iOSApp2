//
//  MainController.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-13.
//

import UIKit

class MainController: UITableViewController, NameEditDelegate {
    // MARK: - List Detail View Controller Delegates
    func nameEditDidCancel(
      _ controller: NameEdit
    ) {
      navigationController?.popViewController(animated: true)
    }

    func nameEdit(
      _ controller: NameEdit,
      didFinishAdding name: Name
    ) {
      let newRowIndex = lists.count
      lists.append(name)

      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)

      navigationController?.popViewController(animated: true)
    }

    func nameEdit(
      _ controller: NameEdit,
      didFinishEditing name: Name
    ) {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        var list = Name(name: "Birthdays")
        lists.append(list)

        list = Name(name: "Groceries")
        lists.append(list)

        list = Name(name: "Cool Apps")
        lists.append(list)

        list = Name(name: "To Do")
        lists.append(list)
    }

    // MARK: - Table view data source

    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return lists.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row) // Remove the item from the array

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Delete the row from the table view
    }
    
    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: cellIdentifier,
        for: indexPath)
      let order = lists[indexPath.row]
      cell.textLabel!.text = order.name
      cell.accessoryType = .detailDisclosureButton

      return cell
    }

    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
      let order = lists[indexPath.row]
      performSegue(
        withIdentifier: "ShowOrders",
        sender: order)
    }

    // MARK: - Navigation
    override func prepare(
      for segue: UIStoryboardSegue,
      sender: Any?
    ) {
      if segue.identifier == "ShowOrders" {
        let controller = segue.destination as! TimsViewController
        controller.order = sender as? Name
      }
        else if segue.identifier == "AddName" {
           let controller = segue.destination as! NameEdit
           controller.delegate = self
         }
    }
    
    override func tableView(
      _ tableView: UITableView,
      accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
      let controller = storyboard!.instantiateViewController(
        withIdentifier: "AddName") as! NameEdit
      controller.delegate = self

      let name = lists[indexPath.row]
      controller.nameToEdit = name

      navigationController?.pushViewController(
        controller,
        animated: true)
    }


}
