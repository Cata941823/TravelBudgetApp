//
//  SignInViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/2/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController: UIViewController{
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var con: Connection = Connection.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        con.openDatabase()
        
        con.createTable(query: "CREATE TABLE IF NOT EXISTS User (id INTEGER Primary KEY Autoincrement, firstname varchar(25) NOT NULL, lastname Varchar(25) NOT NULL, email Varchar(45) UNIQUE NOT NULL, password VARCHAR(25) NOT NULL, monthlyincome INTEGER, monthlyspending INTEGER, plans INTEGER);")

        con.createTable(query: "CREATE TABLE IF NOT EXISTS Destination (id INTEGER Primary KEY Autoincrement, city varchar(25) NOT NULL, country Varchar(25) NOT NULL, avgaccomodation INTEGER NOT NULL, avgfood INTEGER NOT NULL, avgplanetickets INTEGER NOT NULL, avgattractions INTEGER NOT NULL, image BLOB);")
        
        con.createTable(query: "CREATE TABLE IF NOT EXISTS Site (id INTEGER Primary KEY Autoincrement, iddestination INTEGER NOT NULL, name Varchar(45) NOT NULL, price INTEGER NOT NULL, FOREIGN KEY(iddestination) REFERENCES Destination(id));")

        con.createTable(query: "CREATE TABLE IF NOT EXISTS Plan (id INTEGER Primary KEY Autoincrement, name Varchar(45) NOT NULL UNIQUE, iduser INTEGER NOT NULL, totalprice INTEGER NOT NULL, totaldays INTEGER NOT NULL, FOREIGN KEY(iduser) REFERENCES User(id));")

        con.createTable(query: "CREATE TABLE IF NOT EXISTS SitePlan (id INTEGER Primary KEY Autoincrement, idplan INTEGER NOT NULL, idsite INTEGER NOT NULL, FOREIGN KEY(idplan) REFERENCES Plan(id), FOREIGN KEY(idsite) REFERENCES Site(id));")

        con.getAllUser()
        con.closeDB()
    }
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }

     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
     }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        con.closeDB()
        con.openDatabase()
        self.emailAddressTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()

        if (emailAddressTextField.text?.isEmpty)! ||  (passwordTextField.text?.isEmpty)!{
            displayMessage(userMessage: "All fields are required to fill in.")
            return
        }
        else{
            let email = emailAddressTextField.text!
            let pass = passwordTextField.text!
            if(con.logIn(email: email, password: pass))
            {
                print("Login worked!\n")
                var user: User!
                
                //var userList: [User] = []
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : PlatformaViewController = mainStoryboard.instantiateViewController(withIdentifier: "PlatformaViewController") as! PlatformaViewController
                con.getAllUser()
                user = con.getUser(email: email)
                /*
                for user in userList{
                    print("\(user.id) \(String(describing: user.firstname)) \(String(describing: user.lastname)) \(String(describing: user.email)) \(user.income) \(user.spendings)\n")
                }
                */
                user = con.getUser(email: email)
                vc.plan_spendings = user.plan_spendings
                print("User: plan_spendings:--------------- \(user.plan_spendings)")
                vc.id = user.id
                vc.fullName = user.lastname! + " " + user.firstname!
                vc.email = user.email!
                vc.income = user.income
                vc.spendings = user.spendings
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            else{
                print("NOT WORKING\n")
            }
        }

        con.closeDB()
    }
    
    func displayMessage(userMessage: String) -> Void{
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action: UIAlertAction!) in
                DispatchQueue.main.async{
                    //self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let regViewController = storyboard?.instantiateViewController(withIdentifier: "regViewController") as! regViewController
        regViewController.modalPresentationStyle = .fullScreen
        self.present(regViewController, animated: true)
    }
}
