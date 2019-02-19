//
//  MockDataProvider.swift
//  ContactTests
//
//  Created by Kuliza-148 on 19/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
@testable import Contact
import RxSwift

class MockDataProvider<T: Decodable>: DataProvider {
    let apiType: ApiType
    required init(apiType: ApiType) {
        self.apiType = apiType
    }

    func fetchResponse() -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.url(forResource: "contacts", withExtension: "json"), let data = try? Data(contentsOf: path) else { return Disposables.create() }
            guard let userResponse = try? JSONDecoder().decode(T.self, from: data) else {
                observer.onError(NetworkError.cantParse)
                return Disposables.create()
            }
            observer.onNext(userResponse)
            return Disposables.create()
        }
    }

}
