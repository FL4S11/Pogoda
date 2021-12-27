//
//  citiesTVC.swift
//  Pogoda_Murygin
//
//  Created by user on 01.10.2021.
//
import Alamofire
import SwiftyJSON
import UIKit

class citiesTVC: UITableViewController {
    

    @IBOutlet weak var cityTableView: UITableView!
    
    var cityName = ""
    struct Cities {
        var cityName = ""
        var cityTemp = 0.0
    
    }
    
    var cityTempArray:[Cities] = []
    
    func currentWeather(city: String){
        let url = "http://api.weatherapi.com/v1/current.json?key=1d567fce2a854456ac3105417210110&q=London&aqi=\(city)"
        
        
        AF.request(url, method: .get).validate().responseJSON { response in switch response.result {
        case.success(let value):
            let json = JSON(value)
            let name = json["location"]["name"].stringValue
            let temp = json["current"]["temp_c"].doubleValue
            self.cityTempArray.append(Cities(cityName: name, cityTemp: temp))
            self.cityTableView.reloadData()
        case.failure(let error):
            print(error)
        }
        }
    }

    @IBAction func addCityAction(_ sender: UIButton) {
        let alert = UIAlertController(title:"Добавить", message: "Введите название города", preferredStyle: .alert)
        alert.addTextField{(textField) in
        textField.placeholder = "Moscow"
    }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let newCityAction = UIAlertAction(title: "Добавить", style: .default){
            (action) in
            let name = alert.textFields![0].text
            self.currentWeather(city: name!)
        }
        alert.addAction(cancelAction)
        alert.addAction(newCityAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {

        
        super.viewDidLoad()

        cityTableView.delegate = self
        cityTableView.dataSource = self

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityTempArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! citiesNameCell
        cell.cityName.text = cityTempArray[indexPath.row].cityName
        cell.cityName.text = String(cityTempArray[indexPath.row].cityName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath){
        cityName = cityTempArray[indexPath.row].cityName
        performSegue(withIdentifier: "detailVC", sender: self)
    }

   
    }
