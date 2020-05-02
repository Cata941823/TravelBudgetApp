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

    override func viewDidLoad() {
         super.viewDidLoad()
     }
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        if (emailAddressTextField.text?.isEmpty)! ||  (passwordTextField.text?.isEmpty)!{
            displayMessage(userMessage: "All fields are required to fill in.")
            return
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
