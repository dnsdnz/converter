//
//  ViewController.swift
//  converter
//
//  Created by MacBook Air on 30.05.2018.
//  Copyright © 2018 Deniz Cakmak. All rights reserved.
//

import UIKit

struct Currency: Decodable {
    let base: String
    let date: String
    let rates: [String:Double]
}

class ViewController: UIViewController,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversionTableView.dataSource = self
        conversionTableView.allowsSelection = false
        conversionTableView.showsVerticalScrollIndicator = false
        rateField.textAlignment = .center
        fetchData()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let currencyFetched = usd {
                return currencyFetched.rates.count
            }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if let currencyFetched = usd {
            
            cell.textLabel?.text = Array(currencyFetched.rates.keys)[indexPath.row]
            let selectedRate = baseRate * Array(currencyFetched.rates.values)[indexPath.row]
            cell.detailTextLabel?.text = "\(selectedRate)"
            return cell
            
        }
        return UITableViewCell()
        
    }
    
   
    
    @IBOutlet weak var rateField: UITextField!
    
    @IBOutlet weak var conversionTableView: UITableView!
    
    var usd:Currency?
    var baseRate = 1.0
    
    @IBAction func convertPressed(_ sender: UIButton) {
        
        if let iGetString = rateField.text {
            if let isDouble = Double(iGetString) {
                baseRate = isDouble
                fetchData()
                
            }
        }
        
    }
    
    func fetchData() {
        
        let url = URL(string: "https://api.fixer.io/latest?base=USD")
        URLSession.shared.dataTask(with: url!) { (data,response,error) in
            
            if error == nil {
                do {
                    self.usd = try JSONDecoder().decode(Currency.self, from: data!)
                  }
                catch{
                    print("parse error")
                }
                DispatchQueue.main.async {
                   self.conversionTableView.reloadData()
                }
            }
            else {
                print("Error")
                
            }
            
            
        }.resume()
        
    }

}

