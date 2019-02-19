//
//  CustomSection+Extension.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import RxDataSources

struct CustomSection {
    var header: String
    var items: [Item]
}

extension CustomSection: SectionModelType {
    typealias Item = CellRepresentable

    init(original: CustomSection, items: [CellRepresentable]) {
        self = original
        self.items = items
    }
}
