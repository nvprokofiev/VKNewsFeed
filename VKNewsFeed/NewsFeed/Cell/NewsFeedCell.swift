//
//  NewsFeedCell.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-14.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var reposts: String? { get }
    var views: String? { get }
    var photoAttachment: FeedCellPhotoAttachmentViewModel? { get }
    var sizes: FeedCellSizes { get }
}


protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var showMoreButtonFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String { get }
    var width: Int { get }
    var height: Int { get }
}

protocol NewsFeedDelegate: class {
    func revealPost(for cell: NewsFeedCell)
}

class NewsFeedCell: UITableViewCell {

    static let reuseId = "NewsFeedCell"

    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    weak var delegate: NewsFeedDelegate?
    
    override func prepareForReuse() {
        postImageView.image = nil
        iconImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func set(viewModel: FeedCellViewModel) {
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        repostsLabel.text = viewModel.reposts
        viewsLabel.text = viewModel.views
        iconImageView.set(imageURL: viewModel.iconUrlString)
        
        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
        bottomView.frame = viewModel.sizes.bottomViewFrame
        postLabel.frame = viewModel.sizes.postLabelFrame
        postImageView.frame = viewModel.sizes.attachmentFrame
        showMoreButton.frame = viewModel.sizes.showMoreButtonFrame
            }
    
    private func setup() {
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        cardView.backgroundColor = .white
        
        backgroundColor = .clear
        selectionStyle = .none
        
        showMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
    }
    
    @objc func showMoreTapped() {
        delegate?.revealPost(for: self)
    }

}
