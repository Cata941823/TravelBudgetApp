//
//  MoneyViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/12/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class MoneyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var spendingsTextField: UITextField!
    var email: String!
    
    var con: Connection = Connection.init()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //con.openDatabase()
        self.incomeTextField.delegate = self
        self.spendingsTextField.delegate = self
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addIncome(_ sender: Any) {
        
        con.closeDB()
        con.openDatabase()
        self.incomeTextField.resignFirstResponder()
        self.spendingsTextField.resignFirstResponder()

        if((incomeTextField.text?.isEmpty)!){
            displayMessage(userMessage: "You have to introduce a sum in order to change the budget.")
        }
        else{
            con.addIncome(email: self.email, income: incomeTextField.text!)
        }
        con.closeDB()
    }
    
    @IBAction func addSpendings(_ sender: Any) {
        
        con.closeDB()
        con.openDatabase()
        self.incomeTextField.resignFirstResponder()
        self.spendingsTextField.resignFirstResponder()

        if((spendingsTextField.text?.isEmpty)!){
            displayMessage(userMessage: "You have to introduce a sum in order to change the budget.")
        }
        else{
            con.addSpending(email: self.email, spending: spendingsTextField.text!)
        }
        con.closeDB()
    }
    
    @IBAction func backToPlatform(_ sender: Any) {
        con.closeDB()
        con.openDatabase()
        var user: User!
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : PlatformaViewController = mainStoryboard.instantiateViewController(withIdentifier: "PlatformaViewController") as! PlatformaViewController
        con.getAllUser()

        user = con.getUser(email: self.email)
        con.closeDB()
        vc.id = user.id
        vc.fullName = user.lastname! + " " + user.firstname!
        vc.email = user.email!
        vc.income = user.income
        vc.spendings = user.spendings
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
