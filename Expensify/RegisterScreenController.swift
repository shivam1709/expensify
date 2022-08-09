//
//  RegisterScreenController.swift
//  Expensify
//
//  Created by user207261 on 7/19/22.
// Registration controller manages all registration activities

import UIKit
import Firebase
import SwiftUI
import FirebaseAuth 

class RegisterScreenController: UIViewController {

    //references Iboutlet used in register screen
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblValidation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Settings for hiding keyboard while click outside
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    // function to Hide Keyboard while click outside
      @objc func hideKeyboard()
      {
       self.view.endEditing(true)
      }

    //Registration event to register user in firebase authentication
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
        let signUpManager = FirebaseAuthManager()
        lblValidation.text = ""
            signUpManager.createUser(email: email! , password: password!) {[weak self] (success) in
                    guard let `self` = self else { return }
                    var message: String = ""
                    if (success) {
                        message = "Sucessfully registered."
                        self.txtName.text = ""
                        self.txtEmail.text = ""
                        self.txtPassword.text = ""
                        //Add uid to user document after successfull registration
                        let user = Auth.auth().currentUser
                        if let user = user {
                            signUpManager.addUserToFb(uid: user.uid)
                        }
                        
                        //Redirection code to redirect from register scene to Home scene after successfull registration
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeScreenController") as! UIViewController
                        newViewController.modalPresentationStyle = .fullScreen
                        self.present(newViewController, animated:false, completion:nil)

                    } else {
                        message = "Error. Email already exists."
                    }
                self.lblValidation.text = message
            }
        }
        
    }

}
