//
//  DataProvider.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import RxSwift
import Alamofire

protocol DataProvider {
    associatedtype ResponseType: Decodable
    init(apiType: ApiType)
    func fetchResponse() -> Observable<ResponseType>
}

class NetworkProvider<T: Decodable> : DataProvider {
    private let apiType: ApiType

    required init(apiType: ApiType) {
        self.apiType = apiType
    }

    func fetchResponse() -> Observable<T> {
        guard let httpMethod = HTTPMethod(rawValue: apiType.method.rawValue)
            else { return Observable.error(NetworkError.invalidMethod)}
        let url: URL = apiType.baseURL.appendingPathComponent(apiType.path)
        let paramsEncoding: ParameterEncoding = convertParamEncoding(encoding: apiType.parameterEncoding)

        return Observable<T>.create { [unowned self] observer in
            AF.request(url,
                              method: httpMethod,
                              parameters: self.apiType.parameters,
                              encoding: paramsEncoding,
                              headers: nil)
                .responseJSON(completionHandler: { response in
                    guard let jsonData = response.data else {
                        observer.onError(NetworkError.invalidData)
                        Helper.showAlert(message: DisplayString.Validation.networkError)
                        return }
                    guard let userResponse = try? JSONDecoder().decode(T.self, from: jsonData) else {
                        observer.onError(NetworkError.cantParse)
                        return }
                    observer.onNext(userResponse)
                })
            return Disposables.create()
        }
    }

    private func convertParamEncoding(encoding: ParamsEncoding) -> ParameterEncoding {
        switch encoding {
        case .json:
            return JSONEncoding.default
        case .url:
            return URLEncoding.default
        }
    }
}

enum NetworkError: Error {
    case invalidMethod
    case invalidData
    case cantParse
}
