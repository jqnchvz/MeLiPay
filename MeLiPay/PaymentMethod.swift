//
//  PaymentMethod.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import Foundation

struct PaymentMethod: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var payment_type_id: String
    var status: String
    var thumbnail: String
}
