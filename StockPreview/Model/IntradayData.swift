//
//  File.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 07/12/20.
//

import Foundation

// MARK: - IntradayData
struct IntradayData: Decodable{
     let metaData: MetaData
     let timeSeries: [String: TimeSeries1Min]
    
    init(from decoder: Decoder) throws {
        let keyMap = [
            "metaData": ["Meta Data"],
            "timeSeries": ["Time Series (1min)", "Time Series (5min)", "Time Series (15min)", "Time Series (30min)", "Time Series (60min)"]
        ]

        let container = try decoder.container(keyedBy: AnyKey.self)

        self.metaData = try container.decode(MetaData.self, forMappedKey: "metaData", in: keyMap)
        self.timeSeries = try container.decode([String: TimeSeries1Min].self, forMappedKey: "timeSeries", in: keyMap)
    }
}

// MARK: - TimeSeries1Min
struct TimeSeries1Min: Codable {
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

// MARK: - MetaData
struct MetaData: Codable {
    let the1Information, the2Symbol, the3LastRefreshed, the4Interval: String
    let the5OutputSize, the6TimeZone: String

    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4Interval = "4. Interval"
        case the5OutputSize = "5. Output Size"
        case the6TimeZone = "6. Time Zone"
    }
}

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
