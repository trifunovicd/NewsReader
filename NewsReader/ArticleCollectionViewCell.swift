//
//  ArticleCollectionViewCell.swift
//  NewsReader
//
//  Created by Internship on 26/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    let articleImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let articleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articleDescriptionTextView: UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud."
        text.textColor = UIColor.darkGray
        text.font = UIFont.systemFont(ofSize: 16)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    private func setupLayout(){
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false


        contentView.addSubview(scrollView)
        scrollView.addSubview(view)
        view.addSubview(articleImageView)
        view.addSubview(articleNameLabel)
        view.addSubview(articleDescriptionTextView)

        let bottomAnchor = scrollView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)


        bottomAnchor.priority = .defaultLow

        NSLayoutConstraint.activate([


            scrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            bottomAnchor,
            scrollView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),


            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),


            view.widthAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.widthAnchor),


            articleImageView.topAnchor.constraint(equalTo: view.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 250),


            articleNameLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 20),
            articleNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            articleNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),


            articleDescriptionTextView.topAnchor.constraint(equalTo: articleNameLabel.bottomAnchor, constant: 20),
            articleDescriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            articleDescriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            articleDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            articleDescriptionTextView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
