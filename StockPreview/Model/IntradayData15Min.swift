//
//  IntradayData15Min.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

// MARK: - IntradayData15Min
struct IntradayData15Min: Codable {
    let metaData: MetaData
    let timeSeries15Min: [String: TimeSeries15Min]

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries15Min = "Time Series (15min)"
    }
}

// MARK: - TimeSeries15Min
struct TimeSeries15Min: Codable {
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
