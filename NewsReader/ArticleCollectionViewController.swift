//
//  ArticleCollectionViewController.swift
//  NewsReader
//
//  Created by Internship on 26/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "ArticleCollectionViewCell"

class ArticleCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK: Properties
    var articles = [ArticleDetails]()
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        collectionView?.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)

        // Register cell classes
        self.collectionView!.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        guard let collectionView = collectionView else { return }
        let offset = collectionView.contentOffset
        let width = collectionView.bounds.size.width

        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)

        coordinator.animate(alongsideTransition: { (context) in
            collectionView.reloadData()
            collectionView.setContentOffset(newOffset, animated: false)
            
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ArticleCollectionViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleCollectionViewCell.")
        }
    
        let article = articles[indexPath.row]
        cell.configure(article)
        
        cell.onOpenWebviewClicked = { [weak self] in
            self?.openInBrowser(articleUrl: article.url)
        }
        
        return cell
    }

    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: Private Methods
    private func openInBrowser(articleUrl: String){
        let webViewController = WebViewController()
        webViewController.setWebViewURL(articleUrl)
        navigationController?.pushViewController(webViewController, animated: true)
    }

}
