//
//  Connection.swift
//  TravelApp
//
//  Created by user172616 on 5/3/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class Connection: UIViewController {
    
    var db: OpaquePointer?
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TravelDB.sqlite")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func openDatabase(){
        print("\n------------------------------------\nOPENING...\n-------------------\n")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database...\n")
        }
        else{
            print("Database access is open.")
        }
    }
    
    func createTable(query: String){
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        else{
            print("Table succesfully created.")
        }
    }
    
    func insertUser(firstName: String, lastName: String, email: String, password: String){
        
        let insertStatementString = "INSERT INTO User (firstname, lastname, email, password) VALUES (?, ?,?,?);"
        var insertStatement: OpaquePointer?
          // 1
          if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let firstn: NSString = firstName as NSString
            let lastn: NSString = lastName as NSString
            let emailn: NSString = email as NSString
            let pass: NSString = password as NSString
                // 3
                sqlite3_bind_text(insertStatement, 1, firstn.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, lastn.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, emailn.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, pass.utf8String, -1, nil)
                // 4
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("\nSuccessfully inserted row.")
                } else {
                    print("\nCould not insert row.")
                }
            } else {
                print("\nINSERT statement is not prepared.")
            }
            // 5
            sqlite3_finalize(insertStatement)
    }
    
    func closeDB(){
        sqlite3_close(db)
    }
    
    func logIn(email: String, password: String) -> Bool {
        var userList = [User]()
        
        //first empty the list of heroes
        userList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM User where email = ? and password = ?;"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return false
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, email, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding e-mail: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, password, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding password: \(errmsg)")
            return false
        }
    
        //traversing through all the records
        if(sqlite3_step(stmt) == SQLITE_ROW){

            sqlite3_finalize(stmt)

            return true
        }
        else{

            sqlite3_finalize(stmt)

            return false
        }
        
    }

    func addIncome(email: String, income: String){
        var user: User!
        var lastIncome: Int = 0
        var newIncome: Int = 0
        var actualIncome: Int = 0
        user = self.getUser(email: email)
        
        lastIncome = Int(user.income)
        actualIncome = Int(income)!
        newIncome = lastIncome + actualIncome
        
        let updateStatementString = "UPDATE User SET monthlyincome = \(newIncome) WHERE email = '\(email)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error preparing to alter: \(errmsg)")
                return
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }

    func addSpending(email: String, spending: String){
        var user: User!
        var lastSpending: Int = 0
        var newSpending: Int = 0
        var actualSpending: Int = 0
        user = self.getUser(email: email)
        
        lastSpending = Int(user.spendings)
        actualSpending = Int(spending)!
        newSpending = lastSpending + actualSpending
        
        let updateStatementString = "UPDATE User SET monthlyspending = \(newSpending) WHERE email = '\(email)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error preparing to alter: \(errmsg)")
                return
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func searchDestination(destination: String) -> [Destination] {
        var destinationList: [Destination]=[]
            
        //first empty the list of heroes
        destinationList.removeAll()
            
        //this is our select query
        let queryString = "SELECT * FROM User where lower(city) LIKE lower(%\(destination)%) OR lower(country) LIKE lower(%\(destination)%);"
            
        //statement pointer
        var stmt:OpaquePointer?
            
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return destinationList
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let city = String(cString: sqlite3_column_text(stmt, 1))
            let country = String(cString: sqlite3_column_text(stmt, 2))
            let avgaccomodation = sqlite3_column_int(stmt, 3)
            let avgfood = sqlite3_column_int(stmt, 4)
            let avgplanetickets = sqlite3_column_int(stmt, 5)
            let avgattractions = sqlite3_column_int(stmt, 6)
            
            destinationList.append(Destination(id: Int(id), city: String(describing: city), country: String(describing: country), avgaccomodation: Int(avgaccomodation), avgfood: Int(avgfood), avgplanetickets: Int(avgplanetickets), avgattractions: Int(avgattractions)))
        }
        return destinationList
    }
    
    func getUserByEmail(email: String) -> (String, String){
        let queryStatementString = "SELECT * FROM User WHERE email = \(email);"
        var queryStatement: OpaquePointer?
        var monthlyIncome: String?
        var monthlySpending: String?
        
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                // 6
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 6) else {
                    print("Query result is nil")
                    return (monthlyIncome!, monthlySpending!)
                }
                // 7
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 7) else {
                    print("Query result is nil")
                    return (monthlyIncome!, monthlySpending!)
                }
                
                monthlyIncome = String(cString: queryResultCol1)
                monthlySpending = String(cString: queryResultCol2)
            
            }
        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
        return (monthlyIncome!, monthlySpending!)
    }
    
    
    func getAllUser(){
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer?
        
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                // 4
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return
                }
                
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
                    print("Query result is nil")
                    return
                }
                
                guard let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
                    print("Query result is nil")
                    return
                }
                
                guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
                    print("Query result is nil")
                    return
                }
                
                let name = String(cString: queryResultCol1)
                let fname = String(cString: queryResultCol2)
                let email = String(cString: queryResultCol3)
                let pass = String(cString: queryResultCol4)
                // 5
                print("\(id) | \(name) | \(fname) | \(email) | \(pass)")
            }
        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
    }
    
    // MARK: - Cautare Utilizator
    
    func getUser(email: String) -> User {
        let queryStatementString = "SELECT * FROM User WHERE email LIKE '%\(email)%';"
        var queryStatement: OpaquePointer?
        var user: User!
        
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return user
                }
                
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
                    print("Query result is nil")
                    return user
                }
                
                guard let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
                    print("Query result is nil")
                    return user
                }
                
                guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
                    print("Query result is nil")
                    return user
                }
                
                let inc = sqlite3_column_int(queryStatement, 5)
                let spend = sqlite3_column_int(queryStatement, 6)
                
                let name = String(cString: queryResultCol1)
                let fname = String(cString: queryResultCol2)
                let email = String(cString: queryResultCol3)
                let pass = String(cString: queryResultCol4)
                // 5
                print("\(id) | \(name) | \(fname) | \(email) | \(pass) | \(inc) | \(spend)")

                user = User.init(id: Int(id), firstname: name, lastname: fname, email: email, password: pass, income: Int(inc), spendings: Int(spend))
            }
        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
        return user
        
/*        var user: User!
            
        print("1\n")
        //this is our select query
        let queryString = "SELECT * FROM User where email LIKE '%\(email)%';"
            
        //statement pointer
        var stmt:OpaquePointer?
            
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select: \(errmsg)")
            return user
        }
        
        //traversing through all the records
            print("3 junior")
            let id = sqlite3_column_int(stmt, 0)
            print("\(String(cString: sqlite3_column_text(stmt, 1)))")
            let firstname = String(cString: sqlite3_column_text(stmt, 1))
            let lastname = String(cString: sqlite3_column_text(stmt, 2))
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let income = sqlite3_column_int(stmt, 5)
            let spendings = sqlite3_column_int(stmt, 6)

            print("3\n")
            print("\(id) \(firstname) \(lastname) \(email) \(income) \(spendings)")
            
            user! = User(id: Int(id), firstname: String(describing: firstname), lastname: String(describing: lastname), email: String(email), password: String(" "), income: Int(income), spendings: Int(spendings))
        
        
        print("4\n")
        return user*/
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
