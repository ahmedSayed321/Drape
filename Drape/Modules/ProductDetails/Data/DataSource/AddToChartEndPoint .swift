//
//  AddToChartEndPoint .swift
//  Drape
//
//  Created by Me3bed on 06/07/2026.
//

import Foundation

enum AddToChartEndPoint : APIEndpoint{
    var queryParameters: [String : String]? {nil}
    

    case create(DraftOrderRequest)

    
    var baseURL: String { ShopifyConfig.baseURL }
    var path: String {
        "/draft_orders.json"
      }
    var method: HTTPMethod { .post }
    var headers: [String: String] { ShopifyConfig.defaultHeaders }
    
    var body: Encodable? {
        switch self {
        case .create(let request):
            return request   
        }
    }
    
}
