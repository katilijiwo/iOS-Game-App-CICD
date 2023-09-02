//
//  ViewController.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var navigationBar: UIActivityIndicatorView!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var listGame: [GameModel]? = nil
    
    private lazy var viewModel: HomeViewModel = {
        let repository = Injection.init().provideRepository()
        let vm = HomeViewModel(gameRepository: repository)
        vm.didGetListGame = didGetListGame
        return vm
    }()
    
    override func viewDidLoad() {
        setupView()
        setupTableView()
        viewModel.getCategories()
        showIndicator(isHidden: false)
    }
    
    private func setupView(){
        navigationBar.largeContentTitle = "Rawg.io"
    }
    
    private func setupTableView() {
        gameTableView.dataSource = self
        gameTableView.delegate = self
    }
    
    private func didGetListGame(state: Status<[GameModel]>.type?) {        
        switch state {
        case .loading:
            showIndicator(isHidden: false)
            break
        case .result(let data):
            showIndicator(isHidden: true)
            self.listGame = data
            gameTableView.reloadData()
            break
        case .error(let err):
            showIndicator(isHidden: true)
            showErrorMessage(error: err)
            break
        case .none:
            showIndicator(isHidden: true)
            showErrorMessage(error: "Something went wrong")
            break
        }
    }

    private func showIndicator(isHidden: Bool) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = isHidden
            if(isHidden) {
                self.loadingIndicator.stopAnimating()
            } else {
                self.loadingIndicator.startAnimating()
            }
        }
    }

    private func showErrorMessage(error: String) {
        //let message = MDCSnackbarMessage(text: "Something went wrong")
        //MDCSnackbarManager.default.show(message)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ListGameViewTableCell.identifier, for: indexPath) as! ListGameViewTableCell
        let listGame = self.listGame?[indexPath.row]
        if(listGame != nil) {
            cell.setupViews(data: listGame!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameId = Int(listGame?[indexPath.row].id ?? 0)
        let vc = DetailGameViewController()
        vc.newInstance(gameId: gameId)

        self.navigationController?.pushViewController(vc, animated: true)
    }

}

