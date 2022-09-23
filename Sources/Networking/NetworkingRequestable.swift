//
//  Endpoint.swift
//  
//
//  Created by Stig von der Ahé on 20/06/2022.
//

import Foundation

/// Requestable: A protocol to set up all endpoints for a given 'feature/flow'.
public protocol NetworkingRequestable {
    var baseURL: String { get }
    var path: String { get }
    var method: NetworkingRequestableMethod { get }
    var header: [String: String]? { get }
    var body: Data? { get }
}

public enum NetworkingRequestableMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
