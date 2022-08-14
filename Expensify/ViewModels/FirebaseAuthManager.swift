//
//  FirebaseAuthManager.swift
//  Expensify
//
//  Created by user207261 on 8/7/22.
//Firebase authentication implementation

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

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
                completionBlock(true)
            }
        }
    }
    
    //Add uid, email, name to user document after registration
    func addUserToFb(uid : String, email: String, name: String) {
        let db = Firestore.firestore()
        db.collection("user").document().setData([
            "UID": uid,
            "email" : email,
            "name" : name
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //function to update the display name of the user
    func updateDisplayName(name : String, completionBlock: @escaping (_ success: Bool) -> Void){
        let changeName = Auth.auth().currentUser?.createProfileChangeRequest()
        changeName?.displayName = name
        changeName?.commitChanges(completion: {error in
            if let error = error {
                print(error)
                completionBlock(false)
            } else {
                print("DisplayName changed")
                completionBlock(true)
            }
        })
    }
}
