//
//  touristicSitesViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/21/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class touristicSitesViewController: UIViewController {

    var destinations = [Destination]()
    var cityNameArr = [String]()
    
    var searchCity = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension touristicSitesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCity.count
        } else{
            return cityNameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching{
            cell?.textLabel?.text = searchCity[indexPath.row]
        } else{
            cell?.textLabel?.text = cityNameArr[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var destination_: Destination!
        for d in destinations{
            if d.city == cityNameArr[indexPath.row]{
                destination_ = d
            }
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : DetailDestViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailDestViewController") as! DetailDestViewController
        vc.city = destination_.city
        vc.country = destination_.country
        vc.avgaccomodation = destination_.avgaccomodation
        vc.avgplaneticket = destination_.avgplanetickets
        vc.avgfood = destination_.avgfood
        vc.avgsites = destination_.avgattractions
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
