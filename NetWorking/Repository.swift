//
//  Repository.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/5/21.
//

import Foundation
struct ListRepo {
    let repositorys: [Repository]
}

struct Repository{
    
    var repoName : String
    var repoUrl : String
}

extension ListRepo: Decodable{
    private enum ResultsCodingKeys: String, CodingKey {
            case repositorys = ""
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsCodingKeys.self)
        
        repositorys = try container.decode([Repository].self, forKey: .repositorys)
    }
}

extension Repository: Decodable{
    
    private enum RepoCodingKeys: String, CodingKey {
        case repoName = "name"
        case repoUrl = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RepoCodingKeys.self)
        
        repoName = try container.decode(String.self, forKey: .repoName)
        repoUrl = try container.decode(String.self, forKey: .repoUrl)
    }
}
