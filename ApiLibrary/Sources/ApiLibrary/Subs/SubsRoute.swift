//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation
import Alamofire

enum SubsRoute: URLRequestConvertible {
    
    static let apiKey = ""
    static let apiPath = APIHelpers.root + "subs/"
    
    case getList(filmId: String)
    
    
    var header: [String: String]{
        switch self {
        case .getList:
            return [:]
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .getList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getList(let filmId):
            return Self.apiPath + "\(filmId)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getList:
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

