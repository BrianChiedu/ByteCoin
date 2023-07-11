//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Brian Chukwuisiocha on 6/11/23.
//  Copyright © 2023. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func updateUI(_ coinManager: CoinManager, exchangeRate: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9C72C084-E868-44B9-891A-3845DA4DFF05"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let exchangeURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: exchangeURL)
    }
    
    func performRequest(with exchangeURL: String){
        if let url = URL(string: exchangeURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if(error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let exchangeRate = parseJSON(data: safeData){
                        self.delegate?.updateUI(self, exchangeRate: exchangeRate)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastProp = decodedData.rate
            let currency = decodedData.asset_id_quote
            
            let coinObject = CoinModel(currency: currency, rate: lastProp)
            
            return coinObject
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}
