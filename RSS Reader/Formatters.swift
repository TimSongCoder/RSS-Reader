//
//  File.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/5/25.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import Foundation

class Formatters {
    static let userCurrentDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let rssDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
