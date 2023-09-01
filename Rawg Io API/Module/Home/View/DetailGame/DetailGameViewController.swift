//
//  DetailGameViewController.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import UIKit

class DetailGameViewController: UIViewController, UIScrollViewDelegate {

            
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var esrbLbl: UILabel!
    @IBOutlet weak var dscLabel: UILabel!
    
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
        scrollView.delegate = self
        viewModel.getGameDetail(id: gameId)
        
        scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height)

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
        case .error(_):
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
        releaseLbl.text = data.released
        ratingLbl.text = String(data.rating)
        esrbLbl.text = data.esrbRating
        dscLabel.text = data.description
    }
    
}
