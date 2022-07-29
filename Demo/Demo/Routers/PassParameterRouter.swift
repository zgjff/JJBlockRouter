//
//  PassParameterRouter.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

enum PassParameterRouter: String, CaseIterable {
    case byUrl = "/app/passParameterByUrl/:pid/:name"
    case byUrlWithQuery = "/app/search"
    case byContext = "/app/passParameterByContext"
    case mixUrlAndContext = "/app/mixUrlAndContext/:pid/:text"
    case parameterForInit = "/app/parameterForInit/:id"
    case updateUIMatchedSame = "/app/updateUIMatchedSame/:id"
}

extension PassParameterRouter: JJBlockRouterSource {
    var routerPattern: String {
        return rawValue
    }
    
    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJBlockRouterDestination {
        switch self {
        case .byUrl:
            return PassParameterByUrlController()
        case .byUrlWithQuery:
            return PassParameterByUrlWithQueryController()
        case .byContext:
            return PassParameterByContextController()
        case .mixUrlAndContext:
            return PassParameterMixUrlAndContextController()
        case .parameterForInit:
            let idstr = parameters["id"] ?? ""
            let numberFormatter = NumberFormatter()
            let id = numberFormatter.number(from: idstr)?.intValue
            return PassParametersForInitController(id: id ?? 0)
        case .updateUIMatchedSame:
            return UpdateUIWhenMatchSameController()
        }
    }
}
