//
//  ServiceLoader.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import RxSwift
import Alamofire

struct ServiceLoader<U> {
    let item: Observable<U>
    let error: Observable<Error>
    let refreshing: Observable<Bool>

    init(apiCall: @escaping () -> Observable<U>) {
        let trigger = Observable.just(1)

        let networkData = trigger
            .flatMap { _ in apiCall().asObservable().materialize() }
            .share()

        item = networkData
            .map { $0.element }
            .filter {  $0 != nil }
            .map { $0! }

        error = networkData
            .map { $0.error }
            .filter { $0 != nil }
            .map { $0! }

        let loadStarts = trigger.map { _ in true }
        let loadEnds = networkData.delay(0.3, scheduler: MainScheduler.instance).map { _ in false }

        refreshing = Observable.merge([loadStarts, loadEnds]).startWith(false).distinctUntilChanged()
    }
}
