//
//  RepoApi.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/6/21.
//

import Foundation
import Moya


enum RepoApi {
    case getRepo(githubID:String)
}


extension RepoApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.github.com/users/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getRepo(let githubID):
            return "\(githubID)/repos"
        }
    }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case .getRepo:
                return .requestParameters(parameters: ["api_key": ""], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String : String]? {
            return ["Content-type": "application/json"]
        }
    }
