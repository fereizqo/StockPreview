//
//  File.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 07/12/20.
//

import Foundation

// MARK: - IntradayData1Min
//struct IntradayData: Decodable {
//    let metaData: MetaData
//    let timeSeries: [String: TimeSeries]
//
//    enum CodingKeys: String, CodingKey {
//        case metaData = "Meta Data"
//        case timeSeries = "Time Series (1min)"
//    }
//}

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

struct IntradayData: Decodable{
     let metaData: MetaData
     let timeSeries: [String: TimeSeries1Min]
    
    init(from decoder: Decoder) throws {
        let keyMap = [
            "metaData": ["Meta Data"],
            "timeSeries": ["Time Series (1min)", "Time Series (5min)", "Time Series (15min)"]
        ]

        let container = try decoder.container(keyedBy: AnyKey.self)

        self.metaData = try container.decode(MetaData.self, forMappedKey: "metaData", in: keyMap)
        self.timeSeries = try container.decode([String: TimeSeries1Min].self, forMappedKey: "timeSeries", in: keyMap)
//        self.count = try container.decode(Int.self, forMappedKey: "count", in: keyMap)
    }
    
}
