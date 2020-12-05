//
//  URLRequest+Resource.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 05/12/20.
//

import Foundation

extension URLRequest {
    
    init(_ resource: Resource) {
        self.init(url: resource.url)
        self.httpMethod = resource.method
    }
    
}
