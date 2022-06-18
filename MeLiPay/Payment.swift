//
//  Payment.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import Foundation

class Payment: ObservableObject {
    
    @Published var amount: Int = 0
    @Published var paymentMethod: PaymentMethod?
    @Published var bankIssuer: BankIssuer?
    @Published var installments: InstallmentsOption?
  
}
