//
//  TransactionModel.swift
//  Expensify
//
//  Created by user207259 on 8/11/22.
//

class TransactionModel{
    var category = ""
    var amount = ""
    init(category: String, amount: String) {
        self.category = category
        self.amount = amount
    }
}
