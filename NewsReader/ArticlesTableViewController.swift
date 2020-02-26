//
//  ArticlesTableViewController.swift
//  NewsReader
//
//  Created by Internship on 25/02/2020.
//  Copyright © 2020 Internship. All rights reserved.
//

import UIKit
import os.log

private let cellIdentifier = "ArticleTableViewCell"

class ArticlesTableViewController: UITableViewController {
    
    //MARK: Properties
    var articles = [ArticleDetails]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupNavigationBar()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 90
        loadNews()
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell else{
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }
        
        let article = articles[indexPath.row]
        
        cell.articleNameLabel.text = article.title
        cell.articleImageView.loadImageUsingUrlString(urlString: article.urlToImage)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let articleCollectionViewController = ArticleCollectionViewController(collectionViewLayout: layout)
        
        articleCollectionViewController.articles = articles
        articleCollectionViewController.indexPath = indexPath
        
        navigationController?.pushViewController(articleCollectionViewController, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    private func setupNavigationBar(){
        navigationItem.title = "Factory"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 28.0/255.0, green: 68.0/255.0, blue: 156.0/255.0, alpha: 1.0)
    }
    
    private func loadNews() {
        let articleRequest = ArticleRequest()
        articleRequest.getArticles { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let articles):
                self?.articles = articles
            }
        }
    }
    
//    func saveDate(){
//        do {
//            let date = Date()
//            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: date, requiringSecureCoding: true)
//            try archivedData.write(to: Articles.DateArchiveURL)
//        }catch {
//            os_log(OSLogType.debug, "Faild to save date... %@", error.localizedDescription)
//        }
//    }
//
//    func loadDate() -> Date? {
//            do{
//                let fileManager = FileManager.default
//                if !fileManager.fileExists(atPath: Articles.DateArchiveURL.path) {
//                    fileManager.createFile(atPath: Articles.DateArchiveURL.path, contents: nil, attributes: nil)
//                }
//
//                let data = try Data(contentsOf: Articles.DateArchiveURL, options: .alwaysMapped)
//                let archivedDate = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Date
//
//                return archivedDate
//            }
//            catch{
//                os_log(OSLogType.debug, "Faild to load date... %@", error.localizedDescription)
//            }
//
//        return nil
//    }
}
