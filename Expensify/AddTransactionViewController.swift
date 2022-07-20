//
//  AddTransactionViewController.swift
//  Expensify
//
//  Created by user206868 on 7/19/22.
//

import UIKit	
import DropDown

class AddTransactionViewController: UIViewController {

    @IBOutlet weak var incomeButton: UIButton!
    
    @IBOutlet weak var expenseButton: UIButton!
    
    @IBOutlet weak var categoriesDropDoen: UIView!
    @IBOutlet weak var listOfCategories: UILabel!
    
    let dropDown = DropDown()
    let categoriesArray = ["Entertainment",
        "Groceries",
        "Rent",
        "Eating Outside",
        "Fuel"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfCategories.text = "Select Any Category"
        dropDown.anchorView = categoriesDropDoen
        let cancelButton = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        cancelButton.layer.borderWidth = 10
        cancelButton.layer.borderColor = UIColor.black.cgColor
        dropDown.dataSource = categoriesArray
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! )
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
            print("Selected item: \(item) at index: \(index)")
            self.listOfCategories.text = categoriesArray[index]
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func dropDownBtn(_ sender: Any) {
        dropDown.show()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
