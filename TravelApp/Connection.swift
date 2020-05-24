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
    }
    
    func openDatabase(){
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database...\n")
        }
        else{
            print("Database access is open.")
        }
    }

    func closeDB(){
        sqlite3_close(db)
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
    
    func insertUser (firstName: String, lastName: String, email: String, password: String) -> Int{
        
        let insertStatementString = "INSERT INTO User (firstname, lastname, email, password) VALUES (?, ?,?,?);"
        var insertStatement: OpaquePointer?
        var ret: Int = 0
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let firstn: NSString = firstName as NSString
            let lastn: NSString = lastName as NSString
            let emailn: NSString = email as NSString
            let pass: NSString = password as NSString
            
            sqlite3_bind_text(insertStatement, 1, firstn.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, lastn.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, emailn.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, pass.utf8String, -1, nil)
        
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
                ret = 1
            } else {
                print("\nCould not insert row.")
            }
            
        } else {
            print("\nINSERT statement is not prepared.")
        }
        sqlite3_finalize(insertStatement)
        return ret
    }
    
    func logIn(email: String, password: String) -> Bool {
        
        var loggedIn: Bool?
        let queryStatementString = "SELECT * FROM User WHERE email = '\(email)' AND password = '\(password)';"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                print("User found. Succesfully logged in.")
                loggedIn = true
            } else {
                print("\nUser not found.")
                loggedIn = false
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(queryStatement)
        return loggedIn!
    }
    
    func getAllUser(){
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer?
       
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
           
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
            
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
                
                print("\(id) | \(name) | \(fname) | \(email) | \(pass)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func getUser(email: String) -> User {
        let queryStatementString = "SELECT * FROM User WHERE email LIKE '%\(email)%';"
        var queryStatement: OpaquePointer?
        var user: User!
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        
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
                let plan_spend = sqlite3_column_int(queryStatement, 7)
                
                let name = String(cString: queryResultCol1)
                let fname = String(cString: queryResultCol2)
                let email = String(cString: queryResultCol3)
                let pass = String(cString: queryResultCol4)

                print("\(id) | \(name) | \(fname) | \(email) | \(pass) | \(inc) | \(spend)")

                user = User.init(id: Int(id), firstname: name, lastname: fname, email: email, password: pass, income: Int(inc), spendings: Int(spend), plan_spendings: Int(plan_spend))
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return user
    }

    func getUserByEmail(email: String) -> (String, String){
        
        let queryStatementString = "SELECT * FROM User WHERE email = \(email);"
        var queryStatement: OpaquePointer?
        var monthlyIncome: String?
        var monthlySpending: String?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 6) else {
                    print("Query result is nil")
                    return (monthlyIncome!, monthlySpending!)
                }
        
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

    
    func updateUser(email: String, plan_spending: Int){
        var last_plan_spending: Int = 0
        last_plan_spending = self.getUser(email: email).plan_spendings
        
        let updateStatementString = "UPDATE User SET plans = \(last_plan_spending + plan_spending) WHERE email = '\(email)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }

    func addIncome(email: String, income: String) -> Int{
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
        var ret: Int = 0
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
                ret = 1
            } else {
                print("\nCould not update row.")
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error preparing to alter: \(errmsg)")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
        return 1
    }

    func addSpending(email: String, spending: String) -> Int{
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
        var ret: Int = 0
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
        
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
                ret = 1
            } else {
                print("\nCould not update row.")
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error preparing to alter: \(errmsg)")
            }
        } else {
            print("\nCould not update row.")
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing to alter: \(errmsg)")
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
        return ret
    }
    
    func getAllSitesFromPlan(id: Int) -> [String]{
        
        let queryStatementString = "SELECT s.name FROM Site s INNER JOIN SitePlan sp ON sp.idsite = s.id INNER JOIN Plan p ON sp.idplan = p.id WHERE p.id = \(id);"
        var queryStatement: OpaquePointer?
        var Sites = [String]()
        var site_: String!
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil")
                    return Sites
                }
                site_ = String(cString: queryResultCol1)
                Sites.append(site_)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return Sites

    }
    
    func getDestination(plan_id: Int) -> String {
        let queryStatementString = "SELECT d.city FROM Destination d INNER JOIN Site s ON d.id = s.iddestination INNER JOIN SitePlan sp ON s.id = sp.idsite INNER JOIN Plan p ON sp.idplan = p.id WHERE p.id = 1;"
        print("MACAR AICI")
        var queryStatement: OpaquePointer?
        var plan_name_: String!
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            print("DAR AICI")
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                print("AICI CLAR NU")
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil")
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("\nQuery is not prepared \(errorMessage)")
                    return plan_name_
                }
                plan_name_ = String(cString: queryResultCol1)
                return plan_name_
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return plan_name_
    }
    func searchDestination(destination: String) -> [Destination] {
        
        var destinationList: [Destination]=[]
        destinationList.removeAll()
        let queryString = "SELECT * FROM User where lower(city) LIKE lower(%\(destination)%) OR lower(country) LIKE lower(%\(destination)%);"
        var stmt:OpaquePointer?
            
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return destinationList
        }
        
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

    func getAllDestinations() -> [Destination] {
        
        var destinations = [Destination]()
        let queryStatementString = "SELECT * FROM Destination;"
        var queryStatement: OpaquePointer?
            
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            print("AM GASIT DESTINATII")
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                print("AICI")
                
                var dest: Destination
                let id = sqlite3_column_int(queryStatement, 0)
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("\(errorMessage)")
                    return destinations
                }
                    
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("\(errorMessage)")
                    return destinations
                }
                
                let avgacc = sqlite3_column_int(queryStatement, 3)
                let avgf = sqlite3_column_int(queryStatement, 4)
                let avgplane = sqlite3_column_int(queryStatement, 5)
                let avgatt = sqlite3_column_int(queryStatement, 6)
                    
                let city = String(cString: queryResultCol1)
                let country = String(cString: queryResultCol2)
                    
                dest = Destination.init(id: Int(id), city: city, country: country, avgaccomodation: Int(avgacc), avgfood: Int(avgf), avgplanetickets: Int(avgplane), avgattractions: Int(avgatt))
                
                    print("\(id) | \(city) | \(country) | \(avgacc) | \(avgplane) | \(avgatt)")
                destinations.append(dest)
                print("\(city)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return destinations
    }
    
    func insertDestination(city: String, country: String, avgaccomodation: Int, avgfood: Int, avgplanetickets: Int, avgattractions: Int){
        
        let insertStatementString = "INSERT INTO Destination (city, country, avgaccomodation, avgfood, avgplanetickets, avgattractions) VALUES (?,?,?,?,?,?);"
        var insertStatement: OpaquePointer?
          
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let city_: NSString = city as NSString
            let country_: NSString = country as NSString
            let avgacc_: NSInteger = avgaccomodation as NSInteger
            let avgfood_: NSInteger = avgfood as NSInteger
            let avgplane_: NSInteger = avgplanetickets as NSInteger
            let avgattr_: NSInteger = avgattractions as NSInteger
            
            sqlite3_bind_text(insertStatement, 1, city_.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, country_.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(avgacc_))
            sqlite3_bind_int(insertStatement, 4, Int32(avgfood_))
            sqlite3_bind_int(insertStatement, 5, Int32(avgplane_))
            sqlite3_bind_int(insertStatement, 6, Int32(avgattr_))
                
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nDestinatie introdusa.")
            } else {
                print("\nNu s-a putut insera nicio destinatie.")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting DESTINATIE: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func getAllSites(id: Int) -> [Site]{
        var sites = [Site]()
        let queryStatementString = "SELECT * FROM Site WHERE iddestination = \(id);"
        var queryStatement: OpaquePointer?
            
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            print("Atr - AM GASIT Atractii turistice")
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                print("Atr - AICI")
                
                var sit: Site
                let id = sqlite3_column_int(queryStatement, 0)
                let iddest = sqlite3_column_int(queryStatement, 1)
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 2) else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("Atr - \(errorMessage)")
                    return sites
                }
                
                let price = sqlite3_column_int(queryStatement, 3)
                    
                let name = String(cString: queryResultCol1)
                    
                sit = Site.init(id: Int(id), id_destination: Int(iddest), name: name, price: Int(price))
                
                print("Atractii turistice: \(id) | \(iddest) | \(name) | \(price)")
                sites.append(sit)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return sites
    }
    
    func insertSite(iddest: Int, name: String, price: Int){
        
        let insertStatementString = "INSERT INTO Site (iddestination, name, price) VALUES (?,?,?);"
        var insertStatement: OpaquePointer?
          
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let iddestination_: NSInteger = iddest as NSInteger
            let name_: NSString = name as NSString
            let price_: NSInteger = price as NSInteger
            
            sqlite3_bind_int(insertStatement, 1, Int32(iddestination_))
            sqlite3_bind_text(insertStatement, 2, name_.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(price_))
                
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\n Atractie introdusa.")
            } else {
                print("\nNu s-a putut insera nicio atractie.")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting ATRACTIE: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertPlan(name: String, iduser: Int, totalprice: Int, totaldays: Int, planprice: Int, destination: String) -> Int{
        let insertStatementString = "INSERT INTO Plan (name, iduser, totalprice, totaldays, planprice, destination) VALUES (?,?,?,?,?,?);"
        var insertStatement: OpaquePointer?
        var ret: Int = 0
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let name_: NSString = name as NSString
            let iduser_: NSInteger = iduser as NSInteger
            let totalprice_: NSInteger = totalprice as NSInteger
            let totaldays_: NSInteger = totaldays as NSInteger
            let planprice_: NSInteger = planprice as NSInteger
            let destination_: NSString = destination as NSString
            
            sqlite3_bind_text(insertStatement, 1, name_.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(iduser_))
            sqlite3_bind_int(insertStatement, 3, Int32(totalprice_))
            sqlite3_bind_int(insertStatement, 4, Int32(totaldays_))
            sqlite3_bind_int(insertStatement, 5, Int32(planprice_))
            sqlite3_bind_text(insertStatement, 6, destination_.utf8String, -1, nil)
                
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\n Plan introdus.")
                ret = 1
            } else {
                print("\nNu s-a putut insera planul.")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error inserting ATRACTIE: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
        return ret
    }
    
    func insertSitePlan(id_plan: Int, id_site: Int){
        let insertStatementString = "INSERT INTO SitePlan (idplan, idsite) VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let id_plan_: NSInteger = id_plan as NSInteger
            let id_site_: NSInteger = id_site as NSInteger
            
            // 2
            sqlite3_bind_int(insertStatement, 1, Int32(id_plan_))
            // 3
            sqlite3_bind_int(insertStatement, 2, Int32(id_site_))
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSites-Successfully inserted row.")
            } else {
                print("\nSites-Could not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func getPlan(plan_name: String) -> Plan{
        let queryStatementString = "SELECT * FROM Plan WHERE name LIKE '%\(plan_name)%';"
        var queryStatement: OpaquePointer?
        var plan: Plan!
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return plan
                }
                
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 6) else {
                    print("Query result is nil")
                    return plan
                }
                
                
                let iduser = sqlite3_column_int(queryStatement, 2)
                
                let totalprice = sqlite3_column_int(queryStatement, 3)
                
                let totaldays = sqlite3_column_int(queryStatement, 4)
                
                let planprice = sqlite3_column_int(queryStatement, 5)

                let name = String(cString: queryResultCol1)
                let dest = String(cString: queryResultCol2)

                plan = Plan.init(id: Int(id), name: name, id_user: Int(iduser), total_price: Int(totalprice), total_days: Int(totaldays), plan_price: Int(planprice), destination: dest)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return plan
    }
    
    func getAllPlans(iduser: Int) -> [Plan]{
        var plans = [Plan]()
        let queryStatementString = "SELECT * FROM Plan where iduser = \(iduser);"
        var queryStatement: OpaquePointer?
            
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var plan: Plan
                
                let id = sqlite3_column_int(queryStatement, 0)
                    
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return plans
                }
                
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 6) else {
                    print("Query result is nil")
                    return plans
                }
                    
                let iduser = sqlite3_column_int(queryStatement, 2)
                
                let totalprice = sqlite3_column_int(queryStatement, 3)
                
                let totaldays = sqlite3_column_int(queryStatement, 4)
                
                let planprice = sqlite3_column_int(queryStatement, 5)
                
                print("ID____: \(id)\n")
                let name = String(cString: queryResultCol1)
                let dest = String(cString: queryResultCol2)
                
                plan = Plan.init(id: Int(id), name: name, id_user: Int(iduser), total_price: Int(totalprice), total_days: Int(totaldays), plan_price: Int(planprice), destination: dest)
                plans.append(plan)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return plans
    }
}

