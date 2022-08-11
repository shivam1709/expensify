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
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblTotalIncome: UILabel!
    var totalIncome = 0
    @IBOutlet weak var lblTotalExpense: UILabel!
    var totalExpense = 0
    var totalBalance = 0
    var income:String = ""
    var expense:String = ""
    var userName = ""
    @IBOutlet weak var myCollectionView: UICollectionView!
    let db = Firestore.firestore()
    //let user = Auth.auth().currentUser0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        let user = Auth.auth().currentUser
        if user?.displayName != nil{
            self.lblName.text = user!.displayName
        }
        //reading data from DB
        fetchData()


                
    }
        
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        
        cell.monthName.text = monthArr[indexPath.row]
        return cell
    }
    
    func fetchData() {

        db.collection("user")
            .whereField("UID", isEqualTo: Auth.auth().currentUser?.uid)
            .getDocuments(){(querySnapshot,err) in
                if let err = err {
                    print("Error getting documents\(err)")
                
                }else{
                    for document in querySnapshot!.documents{
                        
                        let data = document.data()
                        //print("\(data["amount"]!)")
                        let incomeCheck = data["income"]!
                        
                        if(incomeCheck) as! Bool{
                            self.income = data["amount"]! as? String ?? ""
                            self.totalIncome += Int(self.income) ?? 0
                        }else{
                            self.expense = data["amount"]! as? String ?? ""
                            self.totalExpense += Int(self.expense) ?? 0

                        }
                        
                        
                    }
                    print("\(self.totalIncome)")
                    self.lblTotalIncome.text = "$\(self.totalIncome)"
                    print("\(self.totalExpense)")
                    self.lblTotalExpense.text = "$\(self.totalExpense)"
                    self.totalBalance = (self.totalIncome - self.totalExpense)
                    print("\(self.totalBalance)")
                    self.lblTotalBalance.text = "$\(self.totalBalance)"
                    
                }
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        // call from any screen
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        navigationController?.popToRootViewController(animated: true)
    }
    /*func logoutUser() {
        // call from any screen
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        navigationController?.popToRootViewController(animated: true)
    }**/

    
}

