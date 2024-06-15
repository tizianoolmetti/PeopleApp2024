//
//  Endpoint.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 15/6/2024.
//

import Foundation

enum Endpoint {
    case people(page: Int)
    case details(id: Int)
    case create(data: Data?)
}

// MARK: - HTTPClient Method Type
enum HTTPClientMethodType {
    case GET
    case POST(data: Data?)
    
    var rawValue: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

// MARK: - Host
extension Endpoint {
    var host: String {
        "reqres.in"
    }
    
    var path: String {
        switch self {
        case .people, .create:
            return "/api/users"
        case .details(id: let id):
            return "/api/users/\(id)"
        }
    }
    
    var methodType: HTTPClientMethodType {
        switch self {
        case .people, .details:
            return .GET
        case .create(data: let data):
            return .POST(data: data)
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .people(page: let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        default:
            return []
        }
    }
}

// MARK: - URL
extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        //adding query items
        var requestQueryItems = [URLQueryItem]()
       
        #if DEBUG
        requestQueryItems.append(URLQueryItem(name: "delay", value: "1"))
        #endif
        
        requestQueryItems.append(contentsOf: queryItems)
        
        urlComponents.queryItems = requestQueryItems
        return urlComponents.url
    }
}
