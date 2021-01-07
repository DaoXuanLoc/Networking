//
//  RepoViewModel.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/5/21.
//

import RxSwift
import RxCocoa

class RepoViewModel {
    
    let searchText = PublishSubject<String>()
    
    let isLoading = PublishSubject<Bool>()
    
    lazy var isLoadingValue: Driver<Bool> = {return self.isLoading.asDriver(onErrorJustReturn:true)}()
    
    lazy var data: Driver<[Repository]> = {
        
        return self.searchText.asObservable()
            .filter({$0.count > 0})
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ (string) -> Observable<[Repository]> in
                print("flatMapLatest")
                self.isLoading.onNext(false)
                return RepoViewModel.repositoriesBy(string)
            })
            .flatMapLatest({ (repo) -> Observable<[Repository]> in
                self.isLoading.onNext(true)
                return Observable.just(repo)
            })
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesBy(_ githubID: String) -> Observable<[Repository]> {
        guard !githubID.isEmpty,
              let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
            return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .catchAndReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        
        var repositories = [Repository]()
        
        items.forEach{
            guard let repoName = $0["name"] as? String,
                  let repoURL = $0["html_url"] as? String else {
                return
            }
            repositories.append(Repository(repoName: repoName, repoUrl: repoURL))
        }
        return repositories
    }
}
