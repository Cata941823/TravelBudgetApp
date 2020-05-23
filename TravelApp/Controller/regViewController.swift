//
//  regViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/2/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import Foundation
import UIKit

class regViewController: UIViewController{

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var con: Connection = Connection.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {

        con.closeDB()
        con.openDatabase()
        
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()

        if(firstNameTextField.text!.isEmpty) || (lastNameTextField.text!.isEmpty) || (emailTextField.text!.isEmpty) || (passwordTextField.text!.isEmpty){
            displayMessage(title: "Alert", userMessage: "All fields must be filled in.")
            return
        }
        else{
            if((emailTextField.text?.contains("@"))! && ((emailTextField.text?.contains("."))!) && passwordTextField.text!.count >= 5){
                if(con.insertUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)==1){
                    displayMessage(title: "", userMessage: "User added!")
                }
            }
            else{
                displayMessage(title: "Alert", userMessage: "E-mail invalid and password must contain at least 5 characters/digits/symbols")
            }
            
        }
        con.closeDB()
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        
        let SignInViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        SignInViewController.modalPresentationStyle = .fullScreen
        self.present(SignInViewController, animated: true)
    }
    
    func displayMessage(title: String, userMessage: String) -> Void{
         DispatchQueue.main.async {
             
             let alertController = UIAlertController(title: title, message: userMessage, preferredStyle: .alert)
             
             let OKAction = UIAlertAction(title: "OK", style: .default){
                 (action: UIAlertAction!) in
                 DispatchQueue.main.async{
                    if(title==""){
                        self.dismiss(animated: true, completion: nil)
                    }
                 }
             }
             alertController.addAction(OKAction)
             self.present(alertController, animated: true, completion: nil)
         }
     }
}
