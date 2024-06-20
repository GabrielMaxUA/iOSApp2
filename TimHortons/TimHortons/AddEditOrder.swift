//
//  AddEditOrder.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-05.
//

import UIKit

// Protocol that defines methods for the AddOrderViewController delegate
protocol AddOrderViewControllerDelegate: AnyObject {
  func AddOrderViewControllerDidCancel(_ controller: AddOrderViewController)
    
  func AddOrderViewController(_ controller: AddOrderViewController, didFinishAdding item: OrderItem)
    
  func AddOrderViewController(_ controller: AddOrderViewController, didFinishEditing item: OrderItem)
}

// Controller for adding or editing an order item
class AddOrderViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem! // Button to finish adding or editing
    @IBOutlet weak var textField: UITextField! // Text field to enter item text
    
    weak var delegate: AddOrderViewControllerDelegate? // Delegate to handle actions
    
    var itemToEdit: OrderItem? // Item to be edited (if any)

    // Called when the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never // Disable large title
        
        if let item = itemToEdit {
            title = "Edit Item" // Set title to "Edit Item" if editing
            textField.text = item.text // Set text field to item's text
            doneBarButton.isEnabled = true // Enable done button
        }
    }
    
    @objc func dismissKeyboard() {
         view.endEditing(true)
     }

    // Called just before the view appears on the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder() // Automatically focus on the text field
    }
       
    // MARK: - Text Field Delegates
    
    // Called when the text in the text field is changed
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
        let oldText = textField.text! // Get the current text
        let stringRange = Range(range, in: oldText)! // Get the range to be changed
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string) // Replace the text in the range with new text
        
        doneBarButton.isEnabled = !newText.isEmpty // Enable done button if new text is not empty
   
        return true // Allow the text change
    }

    // Called when the clear button in the text field is pressed
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false // Disable done button
        return true // Allow the clear action
    }

    // Called when the cancel button is pressed
    @IBAction func cancel() {
        delegate?.AddOrderViewControllerDidCancel(self) // Notify delegate that the user canceled
    }

    // Called when the done button is pressed
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text! // Update the item's text
            delegate?.AddOrderViewController(
                self,
                didFinishEditing: item) // Notify delegate that editing is finished
        } else {
            let item = OrderItem() // Create a new order item
            item.text = textField.text! // Set the item's text
            delegate?.AddOrderViewController(self, didFinishAdding: item) // Notify delegate that a new item is added
        }
    }
}
