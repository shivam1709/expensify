//
//  FirebaseAuthManager.swift
//  Expensify
//
//  Created by user207261 on 8/7/22.
//Firebase authentication implementation

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {
    
    //function to create authenticated user - Used in registerscreencontroller
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                if let user = authResult?.user {
                    print(user)
                    completionBlock(true)
                } else {
                    completionBlock(false)
                }
            }
        }
    
    //Function to authenticate user - used in Loginacreecontroller
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
           
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                var user = result?.user
                
                completionBlock(true)
            }
        }
    }
    
    //Add uid to user document after registration
    func addUserToFb(uid : String) {
        let db = Firestore.firestore()
        db.collection("user").document().setData([
            "UID": uid,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
