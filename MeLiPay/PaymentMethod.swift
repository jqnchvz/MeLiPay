//
//  PaymentMethod.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import Foundation

struct PaymentMethod: Codable, Equatable {
    let id: String
    let name: String
    let payment_type_id: String
    let status: String
    let secure_thumbnail: String
    let max_allowed_amount: Int
}
