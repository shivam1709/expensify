//
//  LoginScreenController.swift
//  Expensify
//
//  Created by user207261 on 7/19/22.
//

import UIKit
import Firebase

class LoginScreenController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let db = Firestore.firestore()
        //Settimgs for hiding keyboard while click outside
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    // function to Hide Keyboard while click outside
      @objc func hideKeyboard()
      {
       self.view.endEditing(true)
      }

    
    @IBAction func Login(_ sender: Any) {
          let email : String? = txtEmail.text
          let password : String? = txtPassword.text
          if email?.trimmingCharacters(in: .whitespaces) != ""
          {
          }
          else{
          
          }
          if password?.trimmingCharacters(in: .whitespaces) != ""
          {
          }
          else
          {
              
          }
      }

    
}
