//
//  IntradayData1Min.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

// MARK: - IntradayData1Min
struct IntradayData1Min: Codable {
    let metaData: MetaData
    let timeSeries1Min: [String: TimeSeries1Min]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries1Min = "Time Series (1min)"
    }
}
