//
//  DetailGameViewController.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import UIKit

class DetailGameViewController: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var releaseValueLbl: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var ratingValueLbl: UILabel!
    @IBOutlet weak var esrbImg: UIImageView!
    @IBOutlet weak var esrbValueLbl: UILabel!
    @IBOutlet weak var platformCollectionView: UICollectionView!
    @IBOutlet weak var descLbl: UILabel!
    
    private var gameId = 0
    
    private lazy var viewModel: DetailGameViewModel = {
        let repository = Injection.init().provideRepository()
        let vm = DetailGameViewModel(gameRepository: repository)
        vm.didGetGame = didGetGame
        return vm
    }()
    
    func newInstance(gameId: Int){
        self.gameId = gameId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getGameDetail(id: gameId)
    }

    func didGetGame(state: Status<GameDetailModel>.type?) {
        switch state {
        case .loading:
            showIndicator(isHidden: true)
            break
        case .result(let data):
            displayData(data: data)
            showIndicator(isHidden: false)
            break
        case .error(let err):
            showIndicator(isHidden: false)
            break
        case .none:
            showIndicator(isHidden: false)
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
    
    private func displayData(data: GameDetailModel) {
        gameImg.sd_setImage(with: URL(string: data.bgImage))
        titleLbl.text = data.name
        releaseValueLbl.text = data.released
        ratingValueLbl.text = String(data.rating)
        esrbValueLbl.text = data.esrbRating
        descLbl.text = data.description.htmlToString
    }
    
}
