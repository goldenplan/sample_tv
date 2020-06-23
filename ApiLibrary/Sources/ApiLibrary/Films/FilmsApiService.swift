//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation
import Combine
import Alamofire

public class FilmsApiService: ApiService {
    
    public override init() {}
    
    public func fetchFilms<T: Decodable>() -> AnyPublisher<T, Error> {

        let route = FilmsRoute.getList

        return fetch(route, type: ServerResponse<T>.self)
            .compactMap{$0.object?.result}
            .eraseToAnyPublisher()

    }
    
}

