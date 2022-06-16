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
            
//            URLSession.shared.dataTask(with: requestUrl) {
//                data, response, error in
//
//                let decoder = JSONDecoder()
//
//                if let data = data {
//                    do {
//                        paymentMethods = try decoder.decode([PaymentMethod].self, from: data)
//                    } catch {
//                        print("Unable to decode payment methods information. \(error)")
//                    }
//                    print("HERE1")
//                }
//            }.resume()
        }
        return paymentMethods
    }
    
    func requestBankIssuers(id: String) async -> [BankIssuer] {
        var bankIssuers: [BankIssuer] = []
        
        let baseUrl = "https://api.mercadopago.com/v1/payment_methods?"
        
        if let requestUrl = URL(string: baseUrl + "public_key=" + apiKey) {
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


}
