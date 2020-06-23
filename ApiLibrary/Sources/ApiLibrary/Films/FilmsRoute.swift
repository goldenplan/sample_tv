//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation
import Alamofire

enum FilmsRoute: URLRequestConvertible {
    
    static let apiKey = ""
    static let apiPath = APIHelpers.root + "films/"
    
    case getList
    case getDetail(id: String)
    
    
    var header: [String: String]{
        switch self {
        case .getList, .getDetail:
            return [:]
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .getList, .getDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getList:
            return Self.apiPath
        case .getDetail(let id):
            return Self.apiPath + "\(id)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getList, .getDetail:
            return [:]
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: URL(string: path)!)
        
        request.allHTTPHeaderFields = header
        request.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}

