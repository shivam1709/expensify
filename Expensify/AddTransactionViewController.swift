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
import FirebaseAuth

class AddTransactionViewController: UIViewController {
    
    // All the Outlets
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    
    @IBOutlet weak var categoriesDropDoen: UIView!
    @IBOutlet weak var listOfCategories: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
  
    @IBOutlet weak var amountField: UITextField!
    
    
    @IBOutlet weak var     datePickerTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var vaildatioLabel: UILabel!
    
    // making a object of Firebase
    let db = Firestore.firestore()
    
    //bool to check radio button is selected or not
    var expense = false
    var income = false
    
    // object of dropdown
    let dropDown = DropDown()
    
    //number of category array
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

    override func viewDidLoad() {
        super.viewDidLoad()
        //Code for selecting any category
        listOfCategories.text = "Select Any Category"
        dropDown.anchorView = categoriesDropDoen
        dropDown.dataSource = categoriesArray
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! )
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            print("Selected item: \(item) at index: \(index)")
            self.listOfCategories.text = categoriesArray[index]
        }
        
       
        
        //code for tap gesture to dismiss keyboard
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddTransactionViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        // date picker code
        self.datePickerTextField.datePicker(target: self,
                                  doneAction: #selector(doneAction),
                                  cancelAction: #selector(cancelAction),
                                  datePickerMode: .date)
        // Do any additional setup after loading the view.
    }
    
    // date picker cancel button action
    @objc
        func cancelAction() {
            self.datePickerTextField.resignFirstResponder()
        }
    // date picker done button action
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
    // drop down button pressed
    @IBAction func dropDownBtn(_ sender: Any) {
        dropDown.show()
    }
    
    
    //when a user adds the expense
    @IBAction func addBtn(_ sender: Any) {
        
        //validation to check if empty or not
        if (amountField.text == "" ||
                listOfCategories.text == "" ||
                datePickerTextField.text == "" || 
                (income == false && expense == false)
        ){
           
           vaildatioLabel.text = "Please fill all fields"
        }else{
           
            vaildatioLabel.text = "Your expense is added"
            vaildatioLabel.textColor = UIColor.green
        addDataToFb();
        
        }
    }
    
    // income radio button
    @IBAction func incomeBtn(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            expenseButton.isSelected = false
        }else{
            sender.isSelected = true
            expenseButton.isSelected = false
            expense =  false
           income = true
        }
    }
    
    // expense radio button
    @IBAction func expenseBtn(_ sender: UIButton) {
        if(sender.isSelected){
            sender.isSelected = false
            incomeButton.isSelected = false
        }else{
            sender.isSelected = true
            incomeButton.isSelected = false
            expense =  true
           income = false
        }
    }
    
  		// clear button fuction to clear ecery field
    @IBAction func clearButton(_ sender: Any) {
        listOfCategories.text = "";
        income = false;
        expense = false;
        datePickerTextField.text = "";
        descriptionTextField.text = "";
        amountField.text = ""
    }
    //add button click function to add the data to firebase
    func addDataToFb() {
        let user = Auth.auth().currentUser
        db.collection("user").document().setData([
            "name": user!.displayName,
            "amount":amountField.text,
            "email": user!.email,
            "income":income,
            "expense": expense,
            "category":listOfCategories.text,
            "date":datePickerTextField.text ,
            "description":descriptionTextField.text,
            "UID":user!.uid
            
	        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                //navigating to home screen
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UIViewController
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated:false, completion:nil)
            }
        }
    }
}
    
    // date picker code 
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
