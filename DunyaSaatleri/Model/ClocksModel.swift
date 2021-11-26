//
//  ClocksModel.swift
//  DunyaSaatleri
//
//  Created by Ozan Barış Günaydın on 25.11.2021.
//

import Foundation

// MARK: - Welcome
struct Times: Codable {
    let times: [Time]?
}

// MARK: - Time
struct Time: Codable {
    let city: String?
    let timeZone: String?
    let colorName: String?
    let colorCode: String?
}

//// MARK: - Selected Time
//struct Clock: Codable {
//    let city: String?
//    let timeZone: String?
//    let backgroundColorCode: String?
//    let colorCode: String?
//}



