//
//  MovieService.swift
//  SampleTV
//
//  Created by Stanislav Belsky on 6/23/20.
//  Copyright © 2020 Stanislav Belsky. All rights reserved.
//

import Foundation
import Combine
import ApiLibrary
import Alamofire

protocol FilmsService {
    func fetchFilms<T: Decodable>() -> AnyPublisher<T, Error>
}

extension FilmsApiService: FilmsService{
}

