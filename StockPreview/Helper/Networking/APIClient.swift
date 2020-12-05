//
//  APIClient.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

class APIClient {
    func load (_ resource: Resource, result: @escaping ((Result<Data>) -> Void)) {
        let request = URLRequest(resource)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Get success data
            guard let data = data else {
                result(.failure(APIClientError.noData))
                return
            }
            
            // Get error data
            if let error = error {
                result(.failure(error))
                return
            }
            
            // Retrieve data
            result(.success(data))
        }

        task.resume()
    }
    
}
