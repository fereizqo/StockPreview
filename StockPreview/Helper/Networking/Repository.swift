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
    func getIntradayData1Min(symbol: String, completion: @escaping ((Result<IntradayData1Min>) -> Void)) {
        let resource = Resource(url: URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=1min&apikey=LAOWH18I5MY13PFY")!)
        
        apiClient.load(resource) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(IntradayData1Min.self, from: data)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
             
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getIntradayData5Min(_ completion: @escaping ((Result<IntradayData5Min>) -> Void)) {
        let resource = Resource(url: URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=1min&apikey=LAOWH18I5MY13PFY")!)
        
        apiClient.load(resource) { (result) in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(IntradayData5Min.self, from: data)
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
