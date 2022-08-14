//
//  ViewController.swift
//  CollectionView
//  Reading and displaying data from firebase for homescreen   
//
//  Created by Rahul Patel - 8813239

import UIKit
import FirebaseFirestore
import FirebaseAuth



class HomeScreenController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //connections from Home screen
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblTotalIncome: UILabel!
    @IBOutlet weak var lblTotalExpense: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //variables for calculating data
    var totalIncome = 0
    var totalExpense = 0
    var totalBalance = 0
    var income:String = ""
    var expense:String = ""
    var userName = ""
    var monthlyExpenseArr:[Int] = []
    var monthArrForCollectionV:[String] = []
    var myDictionary:[String:Int] = [:]
    
    //variable for connecting database
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        //implementing collection view
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        
        //displaying user name
        let user = Auth.auth().currentUser
        if user?.displayName != nil{
            self.lblName.text = user!.displayName
        }
        else{
            if user?.email != nil{self.lblName.text = user!.email}
            
        }
        
        //reading data from database using function
        fetchData()

                
    }
        
    
    
    //number of cells in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.monthArrForCollectionV.count
    }
    
    //setting value's of each cell's label
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        cell.monthName.text = self.monthArrForCollectionV[indexPath.row]
        cell.monthlyExpense.text = "$\(self.monthlyExpenseArr[indexPath.row])"
        return cell
    }

    //function for reading data from database
    func fetchData() {
        //connecting with database
        db.collection("user")
            .whereField("UID", isEqualTo: Auth.auth().currentUser?.uid)
            .getDocuments(){(querySnapshot,err) in
                if let err = err {
                    print("Error getting documents\(err)")
                
                }else{
                    //if connection successful traversing through each document from collection of documents
                    for document in querySnapshot!.documents{
                        
                        //dictionary to read each field from a document
                        let data = document.data()
                        if(data["date"] != nil){
                            
                            //getting data for collection view cell
                            //calculating month wise expenses from line 90 to 146
                            //calculation for month wise expenses start
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy/MM/dd"
                            let date = formatter.date(from: data["date"] as! String)
                            let yearMonthFormatter = DateFormatter()
                            yearMonthFormatter.dateFormat = "yyyy/MM"
                            let yearMonthString = yearMonthFormatter.string(from: date!)
                            //print("\(date!) => \(yearMonthString)")
                            if(data["expense"] != nil){
                                let expenseCheck = data["expense"]!
                                if(self.monthArrForCollectionV.isEmpty){
                                    self.monthArrForCollectionV.append(yearMonthString)
                                    if(expenseCheck) as! Bool{
                                        let expns = data["amount"]! as? String ?? ""
                                        let expnsAmount = Int(expns) ?? 0
                                        self.monthlyExpenseArr.append(expnsAmount)
                                    }
                                    else{
                                        self.monthlyExpenseArr.append(0)
                                    }
                                }
                                else if(!self.monthArrForCollectionV.contains(yearMonthString)){
                                    self.monthArrForCollectionV.append(yearMonthString)
                                    if(expenseCheck) as! Bool{
                                        let expns = data["amount"]! as? String ?? ""
                                        let expnsAmount = Int(expns) ?? 0
                                        self.monthlyExpenseArr.append(expnsAmount)
                                    }
                                    else{
                                        self.monthlyExpenseArr.append(0)
                                    }


                                }
                                else{
                                    let index = self.monthArrForCollectionV.firstIndex(of: yearMonthString)
                                    var amount = self.monthlyExpenseArr[index!]
                                    
                                    if(data["expense"] != nil){
                                        let expenseCheck = data["expense"]!
                                        if(expenseCheck) as! Bool{
                                            let expns = data["amount"]! as? String ?? ""
                                            let expnsAmount = Int(expns) ?? 0
                                            amount += expnsAmount
                                            
                                            self.monthlyExpenseArr[index!] = amount
                                        }

                                        self.myCollectionView.reloadData()
                                    }

                                    
                                }
                               
                                
                            }
                            
                        }
                        //calculation for month wise expenses for collection view ends
                        //Calculation for total expense, total balance and total income starts
                        if(data["income"] != nil){
                            let incomeCheck = data["income"]!
                            if(incomeCheck) as! Bool{
                                self.income = data["amount"]! as? String ?? ""
                                self.totalIncome += Int(self.income) ?? 0
                            }else{
                                self.expense = data["amount"]! as? String ?? ""
                                self.totalExpense += Int(self.expense) ?? 0

                            }
                        
                            self.lblTotalIncome.text = "$\(self.totalIncome)"
                            self.lblTotalExpense.text = "$\(self.totalExpense)"
                            self.totalBalance = (self.totalIncome - self.totalExpense)
                            self.lblTotalBalance.text = "$\(self.totalBalance)"
                        }
                        else{
                            self.lblTotalIncome.text = "$0.0"
                            self.lblTotalExpense.text = "$0.0"
                            self.lblTotalBalance.text = "$0.0"
                        }
                        
                        
                    }//Calculation for total expense, total balance and total income ends
                }
        
            }
            
    }
    
    


}

