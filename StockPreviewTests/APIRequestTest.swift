//
//  APIRequestTest.swift
//  StockPreviewTests
//
//  Created by Fereizqo Sulaiman on 07/12/20.
//

import XCTest
@testable import StockPreview

class APIRequestTest: XCTestCase {
    func testGetIntradayData() {
        let expect = XCTestExpectation(description: "Not nil")
        var timeSeriesDict: [String: TimeSeries]?
        
        let repository = Repository(apiClient: APIClient())
        repository.getIntradayData(symbol: "IBM", apiKey: "HBST5HOLYWMZL9FD") { result in
            switch result {
            case .success(let items):
                // Store dict data
                var testDict: [String: TimeSeries] = [:]
                for (key, value) in items.timeSeries {
                    testDict.updateValue(value, forKey: key)
                }
                timeSeriesDict = testDict
                expect.fulfill()
            case .failure(_):
                break
            }
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertNotNil(timeSeriesDict)
    }
    
    func testGetIntradayDataNotMatch() {
        let expect = XCTestExpectation(description: "Not Matched")
        let symbolTest = "IDX"
        var symbolGet = ""
        
        let repository = Repository(apiClient: APIClient())
        repository.getIntradayData(symbol: "IBM", apiKey: "HBST5HOLYWMZL9FD") { result in
            switch result {
            case .success(let items):
                // Compare symbol data
                symbolGet = items.metaData.the2Symbol
                expect.fulfill()
            case .failure(_):
                break
            }
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertFalse(symbolTest == symbolGet)
    }
    
    func testGetDailyData() {
        let expect = XCTestExpectation(description: "Not nil")
        var dailyDataDict: [String: TimeSeriesDaily]?
        
        let repository = Repository(apiClient: APIClient())
        repository.getDailyData(symbol: "IBM", apiKey: "HBST5HOLYWMZL9FD") { result in
            switch result {
            case .success(let items):
                // Store dict data
                var testDict: [String: TimeSeriesDaily] = [:]
                for (key,value) in items.timeSeriesDaily {
                    testDict.updateValue(value, forKey: key)
                }
                dailyDataDict = testDict
                expect.fulfill()
            case .failure(_):
                break
            }
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertNotNil(dailyDataDict)
    }
    
    func testGetDailyDataMatch() {
        let expect = XCTestExpectation(description: "Matched")
        let symbolTest = "IBM"
        var symbolGet = ""
        
        let repository = Repository(apiClient: APIClient())
        repository.getDailyData(symbol: "IBM", apiKey: "HBST5HOLYWMZL9FD") { result in
            switch result {
            case .success(let items):
                // Compare symbol data
                symbolGet = items.metaData.the2Symbol
                expect.fulfill()
            case .failure(_):
                break
            }
        }
        
        wait(for: [expect], timeout: 5)
        XCTAssertTrue(symbolTest == symbolGet)
    }
}
