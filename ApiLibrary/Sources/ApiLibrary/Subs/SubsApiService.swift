//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation
import Combine
import Alamofire

public class SubsApiService: ApiService {
    
    public override init() {}
    
    public func fetchSubs<T: Decodable>(for filmId: String) -> AnyPublisher<T, Error> {

        let route = SubsRoute.getList(filmId: filmId)

        return fetch(route, type: ServerResponse<T>.self)
            .compactMap{$0.object?.result}
            .eraseToAnyPublisher()

    }
    
}
