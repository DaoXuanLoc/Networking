//
//  NetworkManager.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/7/21.
//

import Foundation
import Moya
import RxSwift

protocol Networkable {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
    func getRepo(id: String) -> Single<[Repository]>
}

struct NetworkManager: Networkable {
    let provider = MoyaProvider<RepoApi>(plugins: [NetworkLoggerPlugin()])
    
    func getRepo(id: String) -> Single<[Repository]>{
        provider.rx.request(.getRepo(githubID: id)).map{result in
            do {
                let results =  try JSONDecoder().decode([Repository].self, from: result.data)
                print("getRepo = ", "results.repositorys")
                return results
            } catch _ {
                print("getRepo = ", "null")
                return []
            }
        }
    }
}
