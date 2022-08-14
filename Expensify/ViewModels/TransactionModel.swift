//

//  TransactionModel.swift
//  Expensify
//
//  Created by user207259 on 8/11/22.
//

class TransactionModel{
    var category = ""
    var amount = ""
    var date = ""
    var income:Bool = true
    init(category: String, amount: String, date: String, income: Bool) {
        self.category = category
        self.amount = amount
        self.date = date
        self.income = income
        
    }
}
