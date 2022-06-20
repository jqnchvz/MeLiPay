//
//  PaymentMethod.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import Foundation

// Modelo para método de pago según datos obtenidos desde API de MercadoLibre.
struct PaymentMethod: Codable, Equatable, PaymentData {
    let id: String
    let name: String
    let payment_type_id: String
    let status: String
    let secure_thumbnail: String
    let max_allowed_amount: Int
}
