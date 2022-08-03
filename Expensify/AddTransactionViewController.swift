	//
//  AddTransactionViewController.swift
//  Expensify
//
//  Created by user206868 on 7/19/22.
//

import UIKit	
import DropDown
import FirebaseFirestore
import Foundation

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var incomeButton: UIButton!
    let db = Firestore.firestore()
    @IBOutlet weak var expenseButton: UIButton!
    
    @IBOutlet weak var categoriesDropDoen: UIView!
    @IBOutlet weak var listOfCategories: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButtons: UIButton!
    let dropDown = DropDown()
    let categoriesArray = ["Entertainment",
        "Groceries",
        "Rent",
        "Eating Outside",
        "Fuel",
        "Transportation",
        "Investments",
        "Housing",
        "Shopping",
        "Others"
    ]
    
    @IBOutlet weak var amountField: UITextField!
    
 
    @IBOutlet weak var datePickerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfCategories.text = "Select Any Category"
        dropDown.anchorView = categoriesDropDoen
        cancelButtons.layer.cornerRadius = 10
        cancelButtons.clipsToBounds = true
        let cancelButton = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        cancelButton.layer.borderWidth = 10
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddTransactionViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        // tap gesture to dismiss keyboard
        
        dropDown.dataSource = categoriesArray
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! )
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            print("Selected item: \(item) at index: \(index)")
            self.listOfCategories.text = categoriesArray[index]
        }
      
        self.datePickerTextField.datePicker(target: self,
                                         doneAction: #selector(doneAction),
                                         cancelAction: #selector(cancelAction),
                                         datePickerMode: .date)
        
        datePickerTextField.attributedPlaceholder = NSAttributedString(
            string: "Select Date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        // Do any additional setup after loading the view.
    }

    @objc
        func cancelAction() {
            self.datePickerTextField.resignFirstResponder()
        }
// DATE PICKER DONE BUTTON
        @objc
        func doneAction() {
            if let datePickerView = self.datePickerTextField.inputView as? UIDatePicker {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: datePickerView.date)
                self.datePickerTextField.text = dateString
                
                print(datePickerView.date)
                print(dateString)
                
                self.datePickerTextField.resignFirstResponder()
            }
        }
    
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    //function for minimize keyboard when return button pressed
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // dismiss keyboard
            return true
        }
    @IBAction func dropDownBtn(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        addDataToFb();
    }
    
    @IBAction func incomeBtn(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            expenseButton.isSelected = false
        }else{
            sender.isSelected = true
            expenseButton.isSelected = false
        }
    }
    
    @IBAction func expenseBtn(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            incomeButton.isSelected = false
        }else{
            sender.isSelected = true
            incomeButton.isSelected = false
        }
    }
    
  		

    func addDataToFb() {
        db.collection("user").document().setData([
            "name": "hingu",
            "amount":amountField.text,
            "email": "test@test.com",
            "income":true,
            "expense": false,
            "category":self.listOfCategories.text,
            "date":self.datePickerTextField.text ,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
    extension UITextField {
        func datePicker<T>(target: T,
                           doneAction: Selector,
                           cancelAction: Selector,
                           datePickerMode: UIDatePicker.Mode = .date) {
            let screenWidth = UIScreen.main.bounds.width
            
            func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
                let buttonTarget = style == .flexibleSpace ? nil : target
                let action: Selector? = {
                    switch style {
                    case .cancel:
                        return cancelAction
                    case .done:
                        return doneAction
                    default:
                        return nil
                    }
                }()
                
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                    target: buttonTarget,
                                                    action: action)
                
                return barButtonItem
            }
            
            let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: screenWidth,
                                                        height: 216))
            datePicker.datePickerMode = datePickerMode
            self.inputView = datePicker
            
            let toolBar = UIToolbar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: screenWidth,
                                                  height: 44))
            toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                              buttonItem(withSystemItemStyle: .flexibleSpace),
                              buttonItem(withSystemItemStyle: .done)],
                             animated: true)
            self.inputAccessoryView = toolBar
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
