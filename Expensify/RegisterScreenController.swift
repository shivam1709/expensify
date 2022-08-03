//
//  RegisterScreenController.swift
//  Expensify
//
//  Created by user207261 on 7/19/22.
//

import UIKit
import Firebase
import SwiftUI

class RegisterScreenController: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblValidation: UILabel!
    
    @ObservedObject var model = ViewModel()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Settimgs for hiding keyboard while click outside
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    
    // function to Hide Keyboard while click outside
      @objc func hideKeyboard()
      {
       self.view.endEditing(true)
      }

    @IBAction func Register(_ sender: Any) {
        let name : String? = (self.txtName.text?.trimmingCharacters(in:     CharacterSet.whitespacesAndNewlines))!
           let email : String? = (self.txtEmail.text?.trimmingCharacters(in:     CharacterSet.whitespacesAndNewlines))!
           let password: String? = (self.txtPassword.text?.trimmingCharacters(in:     CharacterSet.whitespacesAndNewlines))!
           var validationStatus : Int = 0
           if name == "" || email == "" || password == ""
           {
            validationStatus = 1
            lblValidation.text = "Please enter all fields"
           }
        else
           {
            if(email != "")
            {
                if(!Validation.isvalidEmail(input: email!))
                {
                    validationStatus = 1
                    lblValidation.text = "Please enter a valid email"
                }
            }
            if(password != "")
            {
                if(!Validation.isvalidPassword(input : password!))
                {
                    validationStatus = 1
                    lblValidation.text = "Password needs min 8 chars and one letter and number"
                }
            }
            
           }
          
        if validationStatus == 0
        {
         lblValidation.text = ""
         model.addUser(name: name! , email: email! , password: password!)
        }
        
    }

}
