//
//  Moya+Extension.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import Foundation

import Moya
import RxSwift

extension MoyaProvider {
    func request<T: Decodable>(_ target: Target, responseDataType: T.Type) -> Single<T> {
        return Single.create { single in
            self.request(target) { result in
                do {
                    switch result {
                    case let .success(response):
                        switch response.statusCode {
                        case 200..<300:
                            let networkResponse = try JSONDecoder().decode(APIResponseDTO<T>.self, from: response.data)
                            return single(.success(networkResponse.data))
                        case 400..<500:
                            single(.failure(NetworkError.clientError))
                        default:
                            single(.failure(NetworkError.unknwon))
                        }
                    case let .failure(error):
                        single(.failure(error))
                    }
                } catch (let error) {
                    if error is DecodingError {
                        single(.failure(NetworkError.decodingError))
                    }
                    single(.failure(NetworkError.unknwon))
                }
            }
            return Disposables.create()
        }
    }
}
