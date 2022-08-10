//
//  ViewController.swift
//  CollectionView
//
//  Created by user206828 on 8/1/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeScreenController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let monthArr:[String] = ["January","February","March","April","May","June", "July", "August", "September", "October", "November", "December"]

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        nameLabel.text = user!.email
        // Do any additional setup after loading the view.
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        
        //reading data from DB
        let docRef = db.collection("user")
        docRef.whereField("UID", isEqualTo: "iTRXjAr5wxXGYprWigmwuIQtI7w1")
            .whereField("Income", isEqualTo: true)
            .getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents:\(err)")
                }else{
                    for document in querySnapshot!.documents{
                        print("\(document.documentID)=>\(document.data())")
                    }
                }
                
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        
        cell.monthName.text = monthArr[indexPath.row]
        return cell
    }
    
}

