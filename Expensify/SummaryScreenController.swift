//
//  ViewController.swift
//  Summary
//  Summary screen
//  Created by user207259 on 7/26/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SummaryScreenController: UIViewController {
    

    @IBOutlet weak var Table1view: UITableView!
    private var userCollectionRef: CollectionReference!
    var dataArray = [TransactionModel]()
    let database = Firestore.firestore()
    let user = Auth.auth().currentUser
    var totalIncome = 0
    var totalBalance = 0
    var totalExpense = 0
    var income:String = ""
    var expense:String = ""
    var date:String = ""
    var incomeValue:Bool = true
    
    
    // Label to display total balance
    @IBOutlet weak var labelBalance: UILabel!
    // Label to display date
    @IBOutlet weak var labelDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        Table1view.register(nib, forCellReuseIdentifier: "TableViewCell")
        Table1view.delegate = self
        Table1view.dataSource = self
        
        userCollectionRef = Firestore.firestore().collection("user")
        
    }
    
    //Function to get data from firestore
    override func viewWillAppear(_ animated: Bool) {
        // Connecting to firebase db based on collection user
        database.collection("user").whereField("UID", isEqualTo: user?.uid).getDocuments { (snapShot, error) in
            if let err = error{
                print("Error fetching documents: \(err)")
            }else{
                guard  let snap = snapShot else {
                    return
                }
                //Iterating over each document
                for document in snap.documents {
                    let data = document.data()
                    if(data["income"] != nil)
                    {
                        let incomeCheck = data["income"]!
                        if(incomeCheck) as! Bool{
                            self.incomeValue = data["income"]! as? Bool ?? true
                            print(self.incomeValue)
                            self.income = data["amount"]! as? String ?? ""
                            self.totalIncome += Int(self.income) ?? 0
                        }
                        else
                        {
                            self.incomeValue = data["income"]! as? Bool ?? false
                            self.expense = data["amount"]! as? String ?? ""
                            self.totalExpense += Int(self.expense) ?? 0
                        }
                        
                        
                    }
                    else{
                        self.labelBalance.text = "No income"
                    }
                    
                    
                    
                    let category = data["category"] as? String ?? ""
                    let amount = data["amount"] as? String ?? ""
                    self.date = data["date"] as? String ?? ""
                    let documentID = document.documentID
                    
                    let transations = TransactionModel(category: category, amount: amount, date:self.date, income:self.incomeValue)
                    self.dataArray.append(transations)
                }
                self.totalBalance = (self.totalIncome - self.totalExpense)
                self.labelBalance.text = "$\(self.totalBalance)"
                
                self.labelDate.text = (self.date)
                self.Table1view.reloadData()
            }
        }
    }
    
}

extension SummaryScreenController : UITableViewDelegate, UITableViewDataSource{
    
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
