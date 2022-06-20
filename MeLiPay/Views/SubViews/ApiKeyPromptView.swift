//
//  ApiKeyPromptView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 20-06-22.
//

import SwiftUI

// Vista con formulario para ingresar llave pública para uso de API de MercadoLibre.
struct ApiKeyPromptView: View {
    @ObservedObject var apiServices: ApiServices
    @State private var apiKey: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text("Bienvenido")
            .font(.largeTitle)
            .padding()
        // Mensaje de bienvenida dependiendo si ya hay una llave ingresada.
        if apiServices.isApiKeyEmpty {
            Text("Para comenzar por favor ingresa tu llave pública para utilizar la API de MercadoLibre.")
                .padding()
        } else {
            Text("Para guardar una nueva llave pública ingrésala aquí.")
                .padding()
        }
        
        TextField("API Key", text: $apiKey, prompt: Text("Ingresa tu llave pública aquí..."))
            .padding()
        
        Button("Guardar") {
            print("Guardando API")
            // Guardar API Key en UserDefaults.
            apiServices.saveApiKey(apiKey)
            // Descartar sheet.
            presentationMode.wrappedValue.dismiss()
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

struct ApiKeyPromptView_Previews: PreviewProvider {
    static var previews: some View {
        ApiKeyPromptView(apiServices: ApiServices())
    }
}
