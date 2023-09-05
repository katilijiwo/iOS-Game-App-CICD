//
//  DetailGameViewController.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import UIKit
import MaterialComponents

class DetailGameViewController: UIViewController {

            
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var platformCollection: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var esrbLbl: UILabel!
    @IBOutlet weak var dscLabel: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var gameId = 0
    private var platforms: [PlatformModel]? = nil
    
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
        platformCollection.delegate = self
        platformCollection.dataSource = self
        platformCollection.register(
            UINib(nibName: PlatformCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier)
    }

    func didGetGame(state: Status<GameDetailModel>.type?) {
        switch state {
        case .loading:
            showIndicator(isHidden: false)
            break
        case .result(let data):
            platforms = data.platforms
            displayData(data: data)
            showIndicator(isHidden: true)
            platformCollection?.reloadData()
            break
        case .error(_):
            showIndicator(isHidden: true)
            break
        case .none:
            showIndicator(isHidden: true)
            break
        }
    }
    
    private func showIndicator(isHidden: Bool) {
        loadingIndicator.isHidden = isHidden
        if(isHidden) {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
    }
    
    private func displayData(data: GameDetailModel) {
        gameImg.sd_setImage(with: URL(string: data.bgImage))
        titleLbl.text = data.name
        releaseLbl.text = data.released
        ratingLbl.text = String(data.rating)
        esrbLbl.text = data.esrbRating
        dscLabel.text = data.description.htmlToString
        dscLabel.numberOfLines = 0
        dscLabel.sizeToFit()
    }
    
    @IBAction func favDidTap(_ sender: UIButton) {
        let message = MDCSnackbarMessage(text: "Game added to favorite")
        MDCSnackbarManager.default.show(message)
    }
    
    
}

extension DetailGameViewController: UICollectionViewDelegate {}

extension DetailGameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlatformCollectionViewCell.identifier, for: indexPath) as! PlatformCollectionViewCell
        let platforms = self.platforms?[indexPath.row]
        if(platforms != nil) {
            cell.setupViews(text: platforms?.name ?? "")
        }
        return cell
    }
}
