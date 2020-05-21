//
//  touristicSitesViewController.swift
//  TravelApp
//
//  Created by user172616 on 5/21/20.
//  Copyright © 2020 user172616. All rights reserved.
//

import UIKit

class touristicSitesViewController: UIViewController {

    var sites = [Site]()
    var siteNameArr = [String]()
    var sitePriceArr = [Int]()
    var sum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for s in sites{
            print("Test: \(String(describing: s.name))\n")
            siteNameArr.append(s.name!)
            sitePriceArr.append(s.price)
            print("\(siteNameArr[0])")
        }
    }

}

extension touristicSitesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = siteNameArr[indexPath.row]
        cell?.detailTextLabel?.text = String(sitePriceArr[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let myCell = tableView.cellForRow(at: indexPath)
        print("AM DAT CLICK PE \(indexPath.row)")
        for s in sites{
            if (myCell?.textLabel?.text?.contains(s.name))!{
                if (myCell?.textLabel?.text?.contains("+ added"))!{
                    myCell?.textLabel?.text = myCell?.textLabel?.text?.replacingOccurrences(of: "+ added", with: "")
                    self.sum -= s.price
                    print("NOW: \(sum)")
                }
                else{
                    myCell?.textLabel?.text = (myCell?.textLabel?.text)! + "+ added"
                    self.sum += s.price
                    print("NOW: \(sum)")
                }
            }
        }
    }

    /*
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        print("NOW: DAT CLICK PE LINIA \(indexPath.row)")
        for s in sites{
            if siteNameArr[indexPath.row].contains(s.name){
                if siteNameArr[indexPath.row].contains("+ added"){
                    cell?.textLabel?.text = siteNameArr[indexPath.row].replacingOccurrences(of: "+ added", with: "")
                    self.sum -= s.price
                    print("NOW: \(sum)")
                }
                else{
                    cell?.textLabel?.text = siteNameArr[indexPath.row] + "+ added"
                    self.sum += s.price
                    print("NOW: \(sum)")
                }
            }
        }
        return cell!
    }*/
}
