//
//  PlatformaViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/5/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class PlatformaViewController: UIViewController {

    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var id: Int!
    var firstname: String = ""
    var lastname: String = ""
    var fullName:String = ""
    var sum:Int = 0
    var email: String = ""
    var income: Int = 0
    var spendings: Int = 0
    var plan_spendings: Int = 0
    var user: User!
    
    var con: Connection = Connection.init()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        con.openDatabase()
        user = con.getUser(email: self.email)
        con.closeDB()
        self.id = user.id
        self.fullName = user.lastname! + " " + user.firstname!
        self.email = user.email!
        self.income = user.income
        self.spendings = user.spendings
        self.plan_spendings = user.plan_spendings
        
        nameLabel?.text = fullName
        sum = income - spendings - plan_spendings
        print("income:\(income) spending:\(spendings) Plans Already:\(plan_spendings)")
        sumLabel?.text = String(sum) + " RON"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOut(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : SignInViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func addMoney(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : MoneyViewController = mainStoryboard.instantiateViewController(withIdentifier: "MoneyViewController") as! MoneyViewController
        vc.email = self.email
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func searchDestinations(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : searchDestViewController = mainStoryboard.instantiateViewController(withIdentifier: "searchDestViewController") as! searchDestViewController
        var user: User!
        user = User.init(id: self.id, firstname: self.firstname, lastname: self.lastname, email: self.email, password: "", income: self.income, spendings: self.spendings, plan_spendings: self.plan_spendings)
        vc.user = user
        vc.email = self.email
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToMyPlans(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : myPlansViewController = mainStoryboard.instantiateViewController(withIdentifier: "myPlansViewController") as! myPlansViewController
        var user: User!
        user = User.init(id: self.id, firstname: self.firstname, lastname: self.lastname, email: self.email, password: "", income: self.income, spendings: self.spendings, plan_spendings: self.plan_spendings)
        vc.user = user
        vc.email = self.email
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
