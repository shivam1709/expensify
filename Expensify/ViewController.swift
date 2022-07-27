//
//  ViewController.swift
//  Summary
//
//  Created by user207259 on 7/26/22.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var Table1view: UITableView!
    var expensesList = ["Groceries", "Entertainment", "Travel", "Rent", "Credit bill", "Shopping"]
    var priceList = ["$55.23", "$23.12", "$56.12", "$545", "$126.55", "$38.23"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        Table1view.register(nib, forCellReuseIdentifier: "TableViewCell")
        Table1view.delegate = self
        Table1view.dataSource = self
        
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(expensesList[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table1view.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.labelCell.text = expensesList[indexPath.row]
        cell.labelPriceCell.text = priceList[indexPath.row]
        cell.imageCell.backgroundColor = .green
        return cell
    }
}

