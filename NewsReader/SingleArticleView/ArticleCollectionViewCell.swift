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
    private let articleImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private  let articleNameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private  let articleDescriptionTextView: UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.isScrollEnabled = false
        text.textColor = UIColor.darkGray
        text.font = UIFont.systemFont(ofSize: 16)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let openInBrowserButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open in browser", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.backgroundColor = UIColor.gray.cgColor
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onOpenWebviewClicked: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Private Methods
    @objc private func openInBrowser(){
        onOpenWebviewClicked!()
    }
    
    func configure(_ article: ArticleDetails){
        articleImageView.loadImageUsingUrlString(urlString: article.urlToImage)
        articleNameLabel.text = article.title
        articleDescriptionTextView.text = article.description
        openInBrowserButton.addTarget(self, action: #selector(openInBrowser), for: .touchUpInside)
    }
    
    private func setupLayout(){
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let containerScrollView = UIView()
        containerScrollView.backgroundColor = .white
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false


        contentView.addSubview(scrollView)
        scrollView.addSubview(containerScrollView)
        containerScrollView.addSubview(articleImageView)
        containerScrollView.addSubview(articleNameLabel)
        containerScrollView.addSubview(articleDescriptionTextView)
        containerScrollView.addSubview(openInBrowserButton)

        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),


            scrollView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.trailingAnchor),


            containerScrollView.widthAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.widthAnchor),
            
            
            articleImageView.topAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 250),


            articleNameLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 20),
            articleNameLabel.leadingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            articleNameLabel.trailingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.trailingAnchor, constant: -20),


            articleDescriptionTextView.topAnchor.constraint(equalTo: articleNameLabel.bottomAnchor, constant: 20),
            articleDescriptionTextView.leadingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            articleDescriptionTextView.trailingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            
            openInBrowserButton.topAnchor.constraint(equalTo: articleDescriptionTextView.bottomAnchor, constant: 20),
            openInBrowserButton.bottomAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            openInBrowserButton.leadingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            openInBrowserButton.trailingAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
