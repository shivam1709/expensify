<<<<<<< Updated upstream
//
//  ViewController.swift
//  Expensify
//
//  Created by user206868 on 7/18/22.
//

import UIKit
import FirebaseAuth

class HomeScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true	
    }


}

=======
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

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblTotalMonthlyExpense: UILabel!
    @IBOutlet weak var lblTotalMonthlyIncome: UILabel!
    var totalIncome:Float = 0
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        let data = document.data()
                        //let amount = data["Amount"] as? String ?? ""
                        //self.totalIncome += Float(amount)!
                        //print("\(self.totalIncome)")
                        print("\(data)")
                    }
                    
                    self.lblTotalMonthlyIncome.text = String(self.totalIncome)
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

>>>>>>> Stashed changes
