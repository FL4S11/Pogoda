//
//  detailVC.swift
//  Pogoda_Murygin
//
//  Created by user on 19.10.2021.
//
import Alamofire
import SwiftyJSON
import UIKit

class detailVC: UIViewController {
    
    var cityName = ""
    
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temp_c: UILabel!
    @IBOutlet weak var counrtyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeather(city: cityName)
        
        let colorTop = UIColor(red: 89/255, green: 156/255, blue: 169/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func currentWeather(city: String){
        let url = "http://api.weatherapi.com/v1/current.json?key=1d567fce2a854456ac3105417210110&q=\(city)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let name = json["location"]["name"].stringValue
                let temp = json["current"]["temp_c"].doubleValue
                let country = json["location"]["country"].stringValue
                let weatherURLString = "http:\(json["location"][0]["icon"].stringValue)"
                
                self.cityNameLabel.text = name
                self.temp_c.text = String(temp)
                self.counrtyLabel.text = country
                
                let weatherURL = URL(string: weatherURLString)
                if let data = try? Data(contentsOf: weatherURL!){
                    self.imageWeather.image = UIImage(data: data)
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}
