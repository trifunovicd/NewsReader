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
    let articleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articleImageView: CustomImageView = {
        let image = CustomImageView(image: #imageLiteral(resourceName: "noimage"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    private func setupLayout(){
        contentView.addSubview(articleNameLabel)
        contentView.addSubview(articleImageView)
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 90),
            articleImageView.widthAnchor.constraint(equalToConstant: 90),
            
            articleNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            articleNameLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 20),
            articleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}
