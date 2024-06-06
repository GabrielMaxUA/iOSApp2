//
//  AddEditOrder.swift
//  TimHortons
//
//  Created by Max Gabriel on 2024-06-05.
//

import UIKit

protocol AddOrderViewControllerDelegate: AnyObject {
  func AddOrderViewControllerDidCancel(_ controller: AddOrderViewController)
    
  func AddOrderViewController(_ controller: AddOrderViewController, didFinishAdding item: OrderItem
  )
    
  func AddOrderViewController(_ controller: AddOrderViewController, didFinishEditing item: OrderItem)
}


class AddOrderViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: AddOrderViewControllerDelegate?
    
    var itemToEdit: OrderItem?


    override func viewDidLoad() {
    super.viewDidLoad()
      navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
           title = "Edit Item"
           textField.text = item.text
            doneBarButton.isEnabled = true
         }
  }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
       
    // MARK: - Text Field Delegates
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
      
      doneBarButton.isEnabled = !newText.isEmpty
   
      return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }

    @IBAction func cancel() {
      delegate?.AddOrderViewControllerDidCancel(self)
    }

    @IBAction func done() {
      if let item = itemToEdit {
        item.text = textField.text!
        delegate?.AddOrderViewController(
          self,
          didFinishEditing: item)
      } else {
        let item = OrderItem()
        item.text = textField.text!
          delegate?.AddOrderViewController(self, didFinishAdding: item)//
      }
    }


}

