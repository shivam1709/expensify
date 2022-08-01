	//
//  AddTransactionViewController.swift
//  Expensify
//
//  Created by user206868 on 7/19/22.
//

import UIKit	
import DropDown
import FirebaseFirestore

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
    
    @IBOutlet weak var txtDatePicker: UILabel!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfCategories.text = "Select Any Category"
        dropDown.anchorView = categoriesDropDoen
        cancelButtons.layer.cornerRadius = 10
        cancelButtons.clipsToBounds = true
        let cancelButton = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        cancelButton.layer.borderWidth = 10
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
        // tap gesture to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

           view.addGestureRecognizer(tap)
        
        dropDown.dataSource = categoriesArray
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! )
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            print("Selected item: \(item) at index: \(index)")
            self.listOfCategories.text = categoriesArray[index]
        }
        // Do any additional setup after loading the view.
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
    
    func showDatePicker(){
      //Formate Date
      datePicker.datePickerMode = .date

     //ToolBar
     let toolbar = UIToolbar();
     toolbar.sizeToFit()
     let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

   toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

    txtDatePicker.inputAccessoryView = toolbar
    txtDatePicker.inputView = datePicker

   }

    @objc func donedatePicker(){

     let formatter = DateFormatter()
     formatter.dateFormat = "dd/MM/yyyy"
     txtDatePicker.text = formatter.string(from: datePicker.date)
     self.view.endEditing(true)
   }

   @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
  }
    func addDataToFb() {
        db.collection("user").document("userData").setData([
            "name": "user1",
            "amount":"50",
            "email": "test@test.com",
            "income":true,
            "expense": false,
            "category":"Fuel",
            "date": "01/07/2022",
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
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
