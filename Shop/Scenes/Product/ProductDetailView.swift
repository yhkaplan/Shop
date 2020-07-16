//
//  ProductDetailView.swift
//  Shop
//
//  Created by josh on 2020/07/09.
//  Copyright © 2020 yhkaplan. All rights reserved.
//

import Foundation
import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        VStack {
            Image(systemName: product.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text("\(product.formattedPrice ?? "-")")
            Spacer()
        }.navigationBarTitle(product.name)
    }
}

#if DEBUG
    extension Product {
        static var previewData: Self {
            .init(id: "123", name: "Banana", price: 7.0, imageURL: "globe")
        }
    }

    struct ProductDetailView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ProductDetailView(product: Product.previewData)
            }
        }
    }
#endif
