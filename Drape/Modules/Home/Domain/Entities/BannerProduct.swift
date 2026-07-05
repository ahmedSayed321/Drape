//
//  BannerProduct.swift
//  Drape
//
//  Created by Me3bed on 05/07/2026.
//

import Foundation

struct BannerProduct: Identifiable, Hashable {
    let id: Int
    let brandName: String
    let imageURL: String
    let postLink: String
}

extension BannerProduct {
    static let mockBanners: [BannerProduct] = [
        BannerProduct(
            id: 1,
            brandName: "Puma",
            imageURL: "https://eg.puma.com/cdn/shop/files/02597602-1_425x.progressive.webp.jpg?v=1759155847https://eg.puma.com/cdn/shop/files/02597602-1_425x.progressive.webp.jpg?v=1759155847",
            postLink: "https://eg.puma.com/en-eg/products/02597602-racing-classics-trucker-caphttps://eg.puma.com/en-eg/products/02597602-racing-classics-trucker-cap"
        ),
        BannerProduct(
            id: 2,
            brandName: "Pull&Bear",
            imageURL: "https://static.pullandbear.net/assets/public/aa21/1e28/800d4c898f34/0b5376f44103/07232522250001-A7M/07232522250001-A7M.jpg?ts=1782888292759&w=550&f=auto",
            postLink: "https://www.pullandbear.com/eg/en/stwd-long-sleeve-tshirt-l07232522?cS=250&pelement=748863173"
        ),
        BannerProduct(
            id: 3,
            brandName: "Nike",
            imageURL: "https://static.nike.com/a/images/t_web_pdp_535_v2/f_auto,u_9ddf04c7-2a9a-4d76-add1-d15af8f0263d,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/350e7f3a-979a-402b-9396-a8a998dd76ab/AIR+FORCE+1+%2707.png",
            postLink: "https://www.nike.com/t/air-force-1-07-mens-shoes-jBrhbr/CT2302-100"
        ),
        BannerProduct(
            id: 4,
            brandName: "Adidas",
            imageURL: "https://assets.adidas.com/images/w_940,f_auto,q_auto/de062172e2f040638bada4dfbfcfc8d9_9366/JF2648_21_model.jpg",
            postLink: "https://www.adidas.com.eg/en/spain-25-women-s-team-away-jersey/JF2648.html"
        )
    ]
}
