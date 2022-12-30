//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coinPrice: CoinPriceModel )
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = CoinApiKey
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print("urlString:\(urlString)")
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Step 1 - create a URL
        if let url = URL(string: urlString) {
            // Step 2 - create URLSession
            let session = URLSession(configuration: .default)

            // Step 3 - give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error:\(error!)")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    print("safeData:\(String(describing: String(data: data!, encoding: .utf8)))")
                    if let price = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(self, coinPrice: price)
                    }
                }
            }

            // Step 4 - start task
            task.resume()
        }
    }
    
    func parseJSON(_ priceData: Data) -> CoinPriceModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinPriceData.self, from: priceData)
            let time = decodedData.time
            let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coinPrice = CoinPriceModel(time:time, asset_id_base:asset_id_base, asset_id_quote:asset_id_quote, rate:rate)
            return( coinPrice )
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
