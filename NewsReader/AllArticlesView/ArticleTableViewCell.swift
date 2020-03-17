//
//  ArticleTableViewCell.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    //MARK: Properties
    private let articleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let articleImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let favoriteButton: UIButton = {
        let favorite = UIButton()
        favorite.translatesAutoresizingMaskIntoConstraints = false
        return favorite
    }()
    
    var onFavoriteClicked: (() -> Void)?
    
    func configure(_ article: ArticlePreview) {
        articleNameLabel.text = article.title
        articleImageView.loadImageUsingUrlString(urlString: article.urlToImage)
        if article.isSelected {
            favoriteButton.isSelected = true
        }
        else {
            favoriteButton.isSelected = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupFavoriteControl()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Private Methods
    private func setupLayout(){
        contentView.addSubview(articleNameLabel)
        contentView.addSubview(articleImageView)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 90),
            articleImageView.widthAnchor.constraint(equalToConstant: 90),
            
            articleNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            articleNameLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 20),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            favoriteButton.leadingAnchor.constraint(equalTo: articleNameLabel.trailingAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 35),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupFavoriteControl(){
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        favoriteButton.setImage(emptyStar, for: .normal)
        favoriteButton.setImage(filledStar, for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteClicked), for: .touchUpInside)
    }
    
    @objc private func favoriteClicked(){
        onFavoriteClicked!()
    }
    
}
