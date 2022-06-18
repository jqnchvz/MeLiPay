//
//  ApiServices.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 15-06-22.
//

import Foundation

class ApiServices {
    
    let apiKey = "444a9ef5-8a6b-429f-abdf-587639155d88"
    
    func requestPaymentMethods() async -> [PaymentMethod] {
        
        var paymentMethods: [PaymentMethod] = []
        
        let baseUrl = "https://api.mercadopago.com/v1/payment_methods?"
        
        if let requestUrl = URL(string: baseUrl + "public_key=" + apiKey) {
            do {
            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            
                if let decodedData = try? JSONDecoder().decode([PaymentMethod].self, from: data) {
                    paymentMethods = decodedData
                }
            } catch {
                print("Invalid data")
            }
        }
        return paymentMethods
    }
    
    func requestBankIssuers(paymentMethodId: String) async -> [BankIssuer] {
        var bankIssuers: [BankIssuer] = []
        
        let baseUrl = "https://api.mercadopago.com/v1/payment_methods"
        
        
        if let requestUrl = URL(string: baseUrl + "/card_issuers?" + "public_key=" + apiKey + "&payment_method_id=" + paymentMethodId) {
            do {
            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            
                if let decodedData = try? JSONDecoder().decode([BankIssuer].self, from: data) {
                    bankIssuers = decodedData
                }
            } catch {
                print("Invalid data")
            }
        }
        return bankIssuers
    }
    
    func requestPaymentInstallments(amount: Int, paymentMethodId: String, bankIssuerId: String) async -> [InstallmentsOption]? {
        var installmentsOptions: InstallmentsOptions? = nil
        
        let baseUrl = "https://api.mercadopago.com/v1/payment_methods"
        
        
        if let requestUrl = URL(string: baseUrl + "/installments?" + "public_key=" + apiKey
                                + "&amount=\(amount)"
                                + "&payment_method_id=" + paymentMethodId
                                + "&issuer.id=" + bankIssuerId
        ) {
            do {
                let (data, _) = try await URLSession.shared.data(from: requestUrl)
                print(requestUrl)
                let decodedData = try JSONDecoder().decode([InstallmentsOptions].self, from: data)
                installmentsOptions = decodedData.first
                print(installmentsOptions)
                
            } catch {
                print("Error: \(error)")
            }
        }
        return installmentsOptions?.payer_costs
    }


}
