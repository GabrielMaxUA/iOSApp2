//
//  NameEdit.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-13.
//

import UIKit

protocol NameEditDelegate: AnyObject {
    
  func nameEditDidCancel(
    _ controller: NameEdit)

  func nameEdit(
    _ controller: NameEdit,
    didFinishAdding name: Name
  )

  func nameEdit(
    _ controller: NameEdit,
    didFinishEditing name: Name
  )
}

class NameEdit: UITableViewController, UITextFieldDelegate {
  @IBOutlet var textField: UITextField!
  @IBOutlet var doneBarButton: UIBarButtonItem!

  weak var delegate: NameEditDelegate?

  var nameToEdit: Name?
    
    override func viewDidLoad() {
      super.viewDidLoad()
        textField.delegate = self
      if let name = nameToEdit {
        title = "Edit Name"
        textField.text = name.name
        doneBarButton.isEnabled = true
      }
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel() {
      print("Cancel button pressed")
      delegate?.nameEditDidCancel(self)
    }

    @IBAction func done() {
      print("Done button pressed")
      if let name = nameToEdit {
        name.name = textField.text!
        delegate?.nameEdit(self, didFinishEditing: name)
      } 
        else {
        let name = Name(name: textField.text!)
        delegate?.nameEdit(self, didFinishAdding: name)
      }
    }
    
    // MARK: - Table View Delegates
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
      return nil
    }

    // MARK: - Text Field Delegates
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

}
