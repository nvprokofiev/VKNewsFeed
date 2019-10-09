//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-11.
//  Copyright (c) 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

    @IBOutlet weak var tableView: UITableView!
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel(cells: [])
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsFeedInteractor()
    let presenter             = NewsFeedPresenter()
    let router                = NewsFeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    tableView.register(UINib(nibName: String(describing: NewsFeedCell.self), bundle: nil), forCellReuseIdentifier: NewsFeedCell.reuseId)
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    
    interactor?.makeRequest(request: .getNewsFeed)
  }
  
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayFeed(let feedViewModel):
        self.feedViewModel = feedViewModel
        tableView.reloadData()
    }
  }
  
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseId, for: indexPath) as! NewsFeedCell
        cell.set(viewModel: feedViewModel.cells[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = feedViewModel.cells[indexPath.row]
        return viewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = feedViewModel.cells[indexPath.row]
        return viewModel.sizes.totalHeight
    }
}

extension NewsFeedViewController: NewsFeedDelegate {
    
    func revealPost(for cell: NewsFeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let viewModel = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: .revealPost(id: viewModel.postId))

    }
}
