//
//  ViewController.swift
//  Summary
//
//  Created by user207259 on 7/26/22.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    

    @IBOutlet weak var Table1view: UITableView!
    private var userCollectionRef: CollectionReference!
    var dataArray = [TransactionModel]()
    let database = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    
    var expensesList = ["Groceries", "Entertainment", "Travel", "Rent", "Credit bill", "Shopping"]
    var priceList = ["$55.23", "$23.12", "$56.12", "$545", "$126.55", "$38.23"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        Table1view.register(nib, forCellReuseIdentifier: "TableViewCell")
        Table1view.delegate = self
        Table1view.dataSource = self
        
        userCollectionRef = Firestore.firestore().collection("user")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        database.collection("user").whereField("UID", isEqualTo: user?.uid).getDocuments { (snapShot, error) in
            if let err = error{
                print("Error fetching documents: \(err)")
            }else{
                guard  let snap = snapShot else {
                    return
                }
                for document in snap.documents {
                    let data = document.data()
                    let category = data["category"] as? String ?? "No value"
                    let amount = data["amount"] as? String ?? "No value"
                    let documentID = document.documentID
                    
                    let transations = TransactionModel(category: category, amount: amount)
                    self.dataArray.append(transations)
                }
                self.Table1view.reloadData()
            }
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print("Selected \(expensesList[indexPath.row])")
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table1view.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        //cell.labelCell.text = dataArray[indexPath.row] as? String
       // cell.labelPriceCell.text = dataArray[indexPath.row] as? String
        cell.configureCell(transaction: dataArray[indexPath.row])
        cell.imageCell.backgroundColor = .green
        return cell
    }
}

