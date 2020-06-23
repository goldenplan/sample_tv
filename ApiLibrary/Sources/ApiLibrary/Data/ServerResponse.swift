//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let error: ErrorData?
    let object: ResponseObject<T>?
}

struct ResponseObject<T: Decodable>: Decodable {
    let result: T
}
