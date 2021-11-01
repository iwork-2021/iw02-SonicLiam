//
//  ItemViewController.swift
//  MyToDo
//
//  Created by Liam on 2021/11/1.
//

import UIKit

protocol AddItemDelegate{
    func addItem(item: TodoItem)
}

protocol EditItemDelegate{
    func editItem(newItem: TodoItem, itemIndex: Int)
}

class ItemViewController: UIViewController {
    
    var addItemDelegate: AddItemDelegate?
    var editItemDelegate: EditItemDelegate?
    var itemToEdit: TodoItem?
    var itemIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doneButton.isEnabled = false
        if itemToEdit != nil{
            doneButton.isEnabled = true
            self.titleInput.text! = itemToEdit!.title
            self.isChecked.isOn = itemToEdit!.isChecked
        }
    }
    

    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var isChecked: UISwitch!
    
    @IBOutlet weak var titleInput: UITextField!
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Done(_ sender: Any) {
        if itemToEdit == nil{
            self.addItemDelegate?.addItem(item: TodoItem(title: titleInput.text!, isChecked: isChecked.isOn))
        }else{
            self.editItemDelegate?.editItem(newItem: TodoItem(title: titleInput.text!, isChecked: isChecked.isOn), itemIndex: self.itemIndex)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

}

extension ItemViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
}
