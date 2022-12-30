//
//  CoinPriceData.swift
//  ByteCoin
//
//  Created by Jason Lau on 30/12/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinPriceData: Codable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
