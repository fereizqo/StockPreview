//
//  Repository.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

class Repository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    // Getting Intraday Data
    func getIntradayData(symbol: String, completion: @escaping ((Result<IntradayData>) -> Void)) {
        guard let userInterval = UserDefaults.standard.string(forKey: "User_Interval"),
              let userOutputSize = UserDefaults.standard.string(forKey: "User_OutputSize") else { return }
        
        let resource = Resource(url: URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&outputsize=\(userOutputSize)&interval=\(userInterval)min&apikey=LAOWH18I5MY13PFY")!)
        
        apiClient.load(resource) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(IntradayData.self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
             
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Get Daily Data
    func getDailyData(symbol: String, completion: @escaping ((Result<DailyData>) -> Void)) {
        guard let _ = UserDefaults.standard.string(forKey: "User_Interval"),
              let userOutputSize = UserDefaults.standard.string(forKey: "User_OutputSize") else { return }
        
        let resource = Resource(url: URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(symbol)&outputsize=\(userOutputSize)&apikey=HBST5HOLYWMZL9FD")!)
        
        
        apiClient.load(resource) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(DailyData.self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
             
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
