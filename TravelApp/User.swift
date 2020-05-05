//
//  User.swift
//  TravelApp
//
//  Created by user172616 on 5/3/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation

class User {
 
    var id: Int
    var firstname: String!
    var lastname: String!
    var email: String!
    var password: String!
    var income: Int
    var spendings: Int
    
    init(id: Int, firstname: String?, lastname: String?, email: String?, password: String?, income: Int, spendings: Int){
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.password = password
        self.income = income
        self.spendings = spendings
    }
}
