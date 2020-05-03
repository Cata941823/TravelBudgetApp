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
        con.openDatabase()
        con.createTable(query: "CREATE TABLE IF NOT EXISTS user (id INTEGER Primary KEY Autoincrement, firstname varchar(25) NOT NULL, lastname Varchar(25) NOT NULL, email Varchar(45) UNIQUE NOT NULL, password VARCHAR(25) NOT NULL, monthlyincome INTEGER, monthlyspending INTEGER);")
        con.createTable(query: "CREATE TABLE IF NOT EXISTS destination (id INTEGER Primary KEY Autoincrement, city varchar(25) NOT NULL, country Varchar(25) NOT NULL, avgaccomodation INTEGER NOT NULL, avgfood INTEGER NOT NULL, avgplanetickets INTEGER NOT NULL, avgattractions INTEGER NOT NULL);")
    }
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
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
            }
            else{
                print("NOT WORKING\n")
            }
        }
    }
    
    func displayMessage(userMessage: String) -> Void{
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){
                (action: UIAlertAction!) in
                DispatchQueue.main.async{
                    self.dismiss(animated: true, completion: nil)
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
