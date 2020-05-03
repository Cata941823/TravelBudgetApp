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
        print("\nMACAR A INTRAT AICI\n")
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let insertString = "INSERT INTO User (firstname, lastname, email, password) VALUES (?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, insertString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing to insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, firstName, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding first name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, lastName, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding last name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, email, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding e-mail: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 4, password, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding password: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure inserting user: \(errmsg)")
            return
        }
        
        //displaying a success message
        print("User saved successfully.")
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
            return true
        }
        else{
            return false
        }
    }

    func addIncome(email: String, income: Int){
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let alterString = "UPDATE User SET monthlyincome = \(income) WHERE email = \(email);"
        
        //preparing the query
        if sqlite3_prepare(db, alterString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing to alter: \(errmsg)")
            return
        }
    }

    func addIncome(email: String, spending: Int){
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let alterString = "UPDATE User SET monthlyspending = \(spending) WHERE email = \(email);"
        
        //preparing the query
        if sqlite3_prepare(db, alterString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing to alter: \(errmsg)")
            return
        }
    }
    
    func searchDestination(destination: String) -> [Destination] {
        var destinationList: [Destination]=[]
            
        //first empty the list of heroes
        destinationList.removeAll()
            
        //this is our select query
        let queryString = "SELECT * FROM Users where lower(city) LIKE lower(%\(destination)%) OR lower(country) LIKE lower(%\(destination)%);"
            
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
