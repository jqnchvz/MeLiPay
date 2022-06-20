//
//  CustomSelectionListView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 19-06-22.
//

import SwiftUI

// Vista personalizada multiuso para generar lista de elementos seleccionables en base a Genéricos.

struct CustomSelectionListView<ItemType: PaymentData, Content: View>: View {
    
    let items: [ItemType]
    @Binding var selection: ItemType?
    let content: (ItemType) -> Content
    
    var body: some View {
        
        ScrollView {
            ForEach(items, id: \.self.id) { item in
                Button {
                    // Hacer toggle al selecionar el mismo u otro item.
                    if selection == item {
                        self.selection = nil
                    } else {
                        self.selection = item
                    }
                } label: {
                    HStack {
                        content(item)
                        
                        Spacer()
                        
                        // Agregar checkmark al seleccionar un item.
                        if selection == item {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.white)
                                .padding()
                        }
                    }
                    .frame(height: 50)
                    .padding([.leading, .trailing])
                    .background(selection == item ? Color.green : .clear) // Colorizar fondo al seleccionar item.
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding()
    }
}

