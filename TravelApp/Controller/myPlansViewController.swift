//
//  myPlansViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/23/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class myPlansViewController: UIViewController {
    var plans = [Plan]()
    var planNameArr = [String]()
    
    var searchPlan = [String]()
    var searching = false
    
    var user: User!
    
    var planPriceArr = [Int]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    var email: String!
    
    var con: Connection = Connection.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        con.openDatabase()
        plans = con.getAllPlans(iduser: user.id)
        for d in plans{
            print("\(d.name)\n")
            planNameArr.append(d.name!)
            print("\(d.total_price)")
            planPriceArr.append(d.total_price)
        }
        
        con.closeDB()
    }
    @IBAction func backToPlatform(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension myPlansViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchPlan.count
        } else{
            return planNameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching{
            cell?.textLabel?.text = searchPlan[indexPath.row]
            cell?.detailTextLabel?.text = String(planPriceArr[indexPath.row]) + " RON"
        } else{
            cell?.textLabel?.text = planNameArr[indexPath.row]
            cell?.detailTextLabel?.text = String(planPriceArr[indexPath.row]) + " RON"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var plan_: Plan!
        for d in plans{
            if d.name == planNameArr[indexPath.row]{
                plan_ = d
            }
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : myDetailPlanViewController = mainStoryboard.instantiateViewController(withIdentifier: "myDetailPlanViewController") as! myDetailPlanViewController
        //vc.destination = con.getDestination(plan_name: plan_.name)
        vc.price = plan_.total_price
        vc.id = plan_.id
        vc.id_user = plan_.id_user
        vc.name = plan_.name
        vc.total_days = plan_.total_days
        vc.sites = con.getAllSitesFromPlan(id: plan_.id)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension myPlansViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchPlan = planNameArr.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        tblView.reloadData()
    }
}
