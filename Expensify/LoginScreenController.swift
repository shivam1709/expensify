//
//  LoginScreenController.swift
//  Expensify
//
//  Created by user207261 on 7/19/22.
//Loginscreen controller for user login activities

import UIKit
import Firebase


class LoginScreenController: UIViewController {

    //references Iboutlet used in login screen
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblValidation: UILabel!
    
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

    //For navigating to to register scene from login scene
    @IBAction func gotoRegister(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterScreenControllerVC") as! UIViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated:false, completion:nil)
    }
    
    //Login event to authorize user and redirect to home screen
    @IBAction func Login(_ sender: Any) {
           let email : String? = (self.txtEmail.text?.trimmingCharacters(in:     CharacterSet.whitespacesAndNewlines))!
           let password: String? = (self.txtPassword.text?.trimmingCharacters(in:     CharacterSet.whitespacesAndNewlines))!
           var validationStatus : Int = 0
           if email == "" || password == ""
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
           }
          
        if validationStatus == 0
        {
            let loginManager = FirebaseAuthManager()
            loginManager.signIn(email: email!, pass: password!) {[weak self] (success) in
                    guard let `self` = self else { return }
                    var message: String = ""
                    if (success) {
                        //Redirection code to redirect from login scene to Home scene after successfull login
                        message = "You are sucessfully logged in."
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeScreenController") as! UIViewController
                        newViewController.modalPresentationStyle = .fullScreen
                        self.present(newViewController, animated:false, completion:nil)
                    } else {
                        message = "Invalid login."
                    }
                self.lblValidation.text = message
                
            }
        }
      }

    
}

