//
//  BankIssuer.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import Foundation

// Modelo para bancos emisores según datos obtenidos desde API de MercadoLibre.
struct BankIssuer: Codable, Equatable, PaymentData {
    let id: String
    let name: String
    let secure_thumbnail: String

}
