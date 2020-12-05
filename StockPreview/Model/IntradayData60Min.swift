//
//  IntradayData60Min.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

// MARK: - IntradayData60Min
struct IntradayData60Min: Codable {
    let metaData: MetaData
    let timeSeries60Min: [String: TimeSeries60Min]

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries60Min = "Time Series (60min)"
    }
}

// MARK: - TimeSeries60Min
struct TimeSeries60Min: Codable {
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
