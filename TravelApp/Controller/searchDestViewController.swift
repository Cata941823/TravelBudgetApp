import UIKit

class searchDestViewController: UIViewController{
    var destinations = [Destination]()
    var cityNameArr = [String]()
    
    var searchCity = [String]()
    var searching = false
    
    var user: User!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    var email: String!
    
    var con: Connection = Connection.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        con.openDatabase()
        destinations = con.getAllDestinations()
        for d in destinations{
            print("\(d.city)\n")
            cityNameArr.append(d.city!)
        }
        con.closeDB()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func backToLogin(_ sender: Any) {
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
}

extension searchDestViewController: UITableViewDataSource, UITableViewDelegate{
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
        vc.user = self.user
        vc.id = destination_.id
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

extension searchDestViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchCity = cityNameArr.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        tblView.reloadData()
    }
}
