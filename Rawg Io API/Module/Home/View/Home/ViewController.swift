//
//  ViewController.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameTableView: UITableView!
    
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
    }
    
    private func setupView(){
        //homeToolbar.largeContentTitle =  "Rawg.io"
    }
    
    private func setupTableView() {
        gameTableView.dataSource = self
        gameTableView.delegate = self
    }
    
    private func didGetListGame(state: Status<[GameModel]>.type?) {
        print("jiwo: " + state.debugDescription.lowercased())
        
        switch state {
        case .loading:
            showIndicator(isHidden: true)
            break
        case .result(let data):
            showIndicator(isHidden: false)
            self.listGame = data
            gameTableView.reloadData()
            break
        case .error(let err):
            showIndicator(isHidden: false)
            showErrorMessage(error: err)
            break
        case .none:
            showIndicator(isHidden: false)
            showErrorMessage(error: "Something went wrong")
            break
        }
    }

    private func showIndicator(isHidden: Bool) {
        //spinnerLoading.isHidden = isHidden
        //if(isHidden) {
        //    spinnerLoading.stopAnimating()
        //} else {
        //    spinnerLoading.startAnimating()
        //}
    }

    private func showErrorMessage(error: String) {
        //let message = MDCSnackbarMessage(text: "Something went wrong")
        //MDCSnackbarManager.default.show(message)
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "game_list_cell", for: indexPath) as! ListGameViewTableCell
        let listGame = self.listGame?[indexPath.row]
        if(listGame != nil) {
            cell.setupViews(data: listGame!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameId = Int32(listGame?[indexPath.row].id ?? 0)
        let vc = DetailGameViewController()

        self.navigationController?.pushViewController(vc, animated: true)
    }

}

