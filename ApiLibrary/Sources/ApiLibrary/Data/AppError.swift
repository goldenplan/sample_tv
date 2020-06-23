//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation

public struct ErrorsData: Codable {
    let errors:  [String]
}

public struct ErrorData: Codable {
    let code:  String
    let description : String
}

public enum ApiError: Error, LocalizedError {
    case apiErrors([String])
    case apiError(ErrorData)
    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case genericError
}

