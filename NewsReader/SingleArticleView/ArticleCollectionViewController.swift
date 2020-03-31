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
    var singleArticleViewModel: SingleArticleViewModel!
    private let bag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView.isPagingEnabled = true
        
        // Register cell classes
        self.collectionView!.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        setObserver()
        
        singleArticleViewModel.scrollToPreselectedItem()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            singleArticleViewModel.coordinatorDelegate?.viewControllerHasFinished()
        }
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
        return singleArticleViewModel.articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ArticleCollectionViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleCollectionViewCell.")
        }
    
        let article = singleArticleViewModel.articles[indexPath.row]
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
        singleArticleViewModel.coordinatorDelegate?.openInBrowser(articleUrl: articleUrl)
    }
    
    private func setObserver() {
        singleArticleViewModel.scrollToItem.subscribe(onNext: { [weak self] indexPath in
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }).disposed(by: bag)
    }
}
