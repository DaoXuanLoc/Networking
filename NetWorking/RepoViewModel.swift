//
//  RepoViewModel.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/5/21.
//

import RxSwift
import RxCocoa

class RepoViewModel {
    
    var networkProvider: NetworkManager!
    
    let searchText = PublishSubject<String>()
    
    let isLoading = PublishSubject<Bool>()
    
    lazy var isLoadingValue: Driver<Bool> = {return self.isLoading.asDriver(onErrorJustReturn:true)}()
    
    lazy var data: Driver<[Repository]> = {
        
        return self.searchText.asObservable()
            .filter({$0.count > 0})
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ (string) -> Single<[Repository]> in
                print("flatMapLatest")
                self.isLoading.onNext(false)
                return self.repositoriesBy(string)
            })
            .flatMapLatest({ (repo) -> Single<[Repository]> in
                self.isLoading.onNext(true)
                return Single.just(repo)
            })
            .asDriver(onErrorJustReturn: [])
    }()
    
    init() {
        networkProvider = NetworkManager()
    }
    
    func repositoriesBy(_ githubID: String) -> Single<[Repository]> {
        return networkProvider.getRepo(id: githubID)
        
    }
}
