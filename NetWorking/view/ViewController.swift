//
//  ViewController.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/5/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak private var repoSearchBar: UISearchBar!
    @IBOutlet weak private var repoTableVIew: UITableView!
    @IBOutlet weak private var viewLoading: UIActivityIndicatorView!
    
    private var viewModel = RepoViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
    }
    
    private func initView(){
        viewLoading.isHidden = true
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "Search Repo"
        repoSearchBar.searchBarStyle = .minimal
        repoTableVIew.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoTableViewCell")
    }
    
    private func bindViewModel(){
        viewModel.data
            .drive(repoTableVIew.rx.items(cellIdentifier: "RepoTableViewCell")) { _, repository, cell in
                guard let repoCell = cell as? RepoTableViewCell else { return }
                repoCell.configCell(repo: repository)
            }
            .disposed(by: disposeBag)
        
        repoSearchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .map { "\($0.count) Repositories" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        repoTableVIew.rx.itemSelected.asObservable().withLatestFrom(viewModel.data){ $1[$0.row] }
            .subscribe { (repository) in
                let xibName = "DetailRepoViewController"
                let viewController = DetailRepoViewController(nibName: String(describing: xibName), bundle: nil)
                viewController.repo = repository.element
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
