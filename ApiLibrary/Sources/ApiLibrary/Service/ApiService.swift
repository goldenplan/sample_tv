//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation
import Combine
import Alamofire

public class ApiService {
    
    private let urlSession = URLSession.shared
    private var subscriptions = Set<AnyCancellable>()
    
    func fetch<T: Decodable>(_ route: URLRequestConvertible, type: T.Type) -> Future<T, Error> {
        
        return Future<T, Error>{  [unowned self]  promise in
            do{
                
                let request = try route.asURLRequest()
                print("Запрос пошел", request.urlRequest ?? "nil")
                
                self.urlSession.dataTaskPublisher(for: request)
                    .tryMap { (data, response) -> Data in
                        
                        if let apiErrors = try? APIHelpers.jsonDecoder.decode(ErrorsData.self, from: data){
                            throw ApiError.apiErrors(apiErrors.errors)
                        }
                        
                        if let apiError = try? APIHelpers.jsonDecoder.decode(ErrorData.self, from: data){
                            throw ApiError.apiError(apiError)
                        }
                     
                        guard let httpResponse = response as? HTTPURLResponse,
                            200...299 ~= httpResponse.statusCode else{
                                throw ApiError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                        }
                        
                        return data
                }
                .decode(type: T.self, decoder: APIHelpers.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (complition) in
                    
                        if case let .failure(error) = complition{
                            switch error {
                            case let urlError as URLError:
                                promise(.failure(ApiError.urlError(urlError)))
                            case let decodingError as DecodingError:
                                promise(.failure(ApiError.decodingError(decodingError)))
                            case let apiError as ApiError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(ApiError.genericError))
                            }
                        }
                    
                }) { promise(.success($0)) }
                .store(in: &self.subscriptions)
                
            }catch{
                promise(.failure(ApiError.urlError(URLError(URLError.unsupportedURL))))
            }
        }
    }
}

