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
    
    @Published var paymentInProcess = false
    
    @Published var paymentComplete = false
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
            formatter.numberStyle = .currency

        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    func resetPayment() {
        amount = 0
        paymentMethod = nil
        bankIssuer = nil
        installments = nil
        paymentInProcess = false
        paymentComplete = false
    }
  
}
