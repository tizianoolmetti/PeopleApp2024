//
//  HTTPClient.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 14/6/2024.
//

import Foundation

// MARK: - HTTPClientError
enum HTTPClientError: LocalizedError, Equatable {
    case invalidURL
    case invalidStatusCode(statusCode: Int)
    case invalidData
    case decodingError
    case sessionError
    case customError(error: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidStatusCode(let statusCode):
            return "Invalid Status Code: \(statusCode)"
        case .invalidData:
            return "Invalid Data"
        case .decodingError:
            return "Decoding Error"
        case .sessionError:
            return "Session Error"
        case .customError(let error):
            return error
        }
    }
    
}

// MARK: - Make HTTPClientError Equatable
//extension HTTPClientError: Equatable {
//    static func == (lhs: HTTPClientError, rhs: HTTPClientError) -> Bool {
//        switch (lhs, rhs) {
//        case (.invalidURL, .invalidURL):
//            return true
//        case (.invalidStatusCode(let lhsStatusCode), .invalidStatusCode(let rhsStatusCode)):
//            return lhsStatusCode == rhsStatusCode
//        case (.invalidData, .invalidData):
//            return true
//        case (.decodingError, .decodingError):
//            return true
//        case (.sessionError, .sessionError):
//            return true
//        case (.customError(let lhsError), .customError(let rhsError)):
//            return lhsError == rhsError
//        default:
//            return false
//        }
//    }
//}

protocol HTTPClientProtocol {
    
    func request<T: Codable>(
        session: URLSession,
        endpoint: Endpoint,
        type: T.Type
    ) async throws -> T
    
    func request(
        session: URLSession,
        endpoint: Endpoint
    ) async throws
}

extension HTTPClientProtocol {
    
    func request<T: Codable>(
        session: URLSession = URLSession.shared,
        endpoint: Endpoint,
        type: T.Type
    ) async throws -> T {
        // Provide the default implementation or just call the protocol method
        try await request(session: session, endpoint: endpoint, type: type)
    }
    
    func request(
        session: URLSession = URLSession.shared,
        endpoint: Endpoint
    ) async throws {
        // Provide the default implementation or just call the protocol method
        try await request(session: session, endpoint: endpoint)
    }
}

// MARK: - HTTPClient
final class HTTPClient: HTTPClientProtocol {
    
    static let shared = HTTPClient()
    
    init() {}
    
    // GET: Using completion Handler
    func request<T: Codable>(
        session: URLSession = URLSession.shared,
        endpoint: Endpoint,
        type: T.Type,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) {
        
        guard let url = endpoint.url else {
            completion(.failure(HTTPClientError.invalidURL))
            return
        }
        
        let request = buildRequest(methodType: endpoint.methodType, url: url)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(HTTPClientError.customError(error: "URLSession Error")))
                return
            }
            
            //Validate HTTP Response
            do {
                try self.validateHTTPResponse(response: response)
            } catch {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(HTTPClientError.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodeData =  try decoder.decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(HTTPClientError.decodingError))
            }
        }
        dataTask.resume()
    }
    
    // GET: Using asynAwait
    func request<T: Codable>(
        session: URLSession = URLSession.shared,
        endpoint: Endpoint,
        type: T.Type
    ) async throws -> T {
        
        guard let url = endpoint.url else {
            throw HTTPClientError.invalidURL
        }
        
        let request = buildRequest(methodType: endpoint.methodType, url: url)
        
        let (data, response) = try await session.data(for: request)
        
        //Validate HTTP Response
        do {
            try self.validateHTTPResponse(response: response)
        } catch {
            throw error
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw HTTPClientError.decodingError
        }
    }
    
    
    // POST: Using completion Handler
    
    func request(
        session: URLSession = URLSession.shared,
        endpoint: Endpoint,
        completion: @escaping ((Result<Void, Error>) -> Void)) {
        
        guard let url = endpoint.url else {
            completion(.failure(HTTPClientError.invalidURL))
            return
        }
        
        let request = buildRequest(methodType: endpoint.methodType, url: url)
        
            let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(HTTPClientError.customError(error: "URLSession Error")))
                return
            }
            
            //Validate HTTP Response
            do {
                try self.validateHTTPResponse(response: response)
            } catch {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
        dataTask.resume()
    }
    
    // POST: Using completion Handler
    
    func request(session: URLSession = URLSession.shared, endpoint: Endpoint) async throws{
        
        guard let url = endpoint.url else {
            throw HTTPClientError.invalidURL
        }
        
        let request = buildRequest(methodType: endpoint.methodType, url: url)
        
        let (_, response) = try await session.data(for: request)
        
        //Validate HTTP Response
        do {
            try self.validateHTTPResponse(response: response)
        } catch {
            throw error
        }
    }
}

extension HTTPClient {
    func buildRequest(methodType: HTTPClientMethodType,
                      url: URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = methodType.rawValue
        case .POST(data: let data):
            request.httpMethod = methodType.rawValue
            request.httpBody = data
        }
        
        return request
    }
    
    func validateHTTPResponse(response: URLResponse?) throws {
        guard
            let response = response as? HTTPURLResponse,
            (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw HTTPClientError.invalidStatusCode(statusCode: statusCode)
        }
    }
}



