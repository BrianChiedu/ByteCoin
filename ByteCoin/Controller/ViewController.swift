//
//  ViewController.swift
//  ByteCoin
//
//  Created by Brian Chukwuisiocha on 6/11/23.
//  Copyright © 2023. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var coinManager = CoinManager()
        
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

}

//MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    func updateUI(_ coinManager: CoinManager, exchangeRate: CoinModel) {
        var exchangeRateString = String(format: "%.2f", exchangeRate.rate)
        DispatchQueue.main.async {
            self.bitcoinLabel.text = exchangeRateString
            self.currencyLabel.text = exchangeRate.currency
        }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

