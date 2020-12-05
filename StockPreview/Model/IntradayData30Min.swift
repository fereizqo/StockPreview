//
//  IntradayData30Min.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

// MARK: - IntradayData30Min
struct IntradayData30Min: Codable {
    let metaData: MetaData
    let timeSeries30Min: [String: TimeSeries30Min]

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries30Min = "Time Series (30min)"
    }
}

// MARK: - TimeSeries30Min
struct TimeSeries30Min: Codable {
    let the1Open, the2High, the3Low, the4Close: String
    let the5Volume: String

    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
        case the2High = "2. high"
        case the3Low = "3. low"
        case the4Close = "4. close"
        case the5Volume = "5. volume"
    }
}
