//
//  ListItemWithThumbnail.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 20-06-22.
//

import SwiftUI
// Vista personalizada multiuso para estilizar cada elemento de una lista.

struct ListItemWithThumbnail: View {
    var text: String = ""
    var thumbnailUrlString: String?
    
    var body: some View {
        HStack{
            // Agregar thumbnail si está disponible o placeholder si no.
            if let thumbnailUrlString = thumbnailUrlString {
                if let thumbnailUrl = URL(string: thumbnailUrlString) {
                    AsyncImage(url: thumbnailUrl) { image in // Permite carga asíncrona de imágenes obtenidas de la web.
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                    } placeholder: {
                        Color.gray
                            .frame(width: 50, height: 20)
                    }
                }
            }
            // Texto a mostrar para el item.
            Text(text)
        }
    }
}

struct ListItemWithThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        ListItemWithThumbnail(text: "TestListItem", thumbnailUrlString: "https://http2.mlstatic.com/storage/logos-api-admin/ce454480-445f-11eb-bf78-3b1ee7bf744c-xl@2x.png" )
    }
}
