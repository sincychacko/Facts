//
//  ViewController.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import UIKit
import SVProgressHUD

class FactsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    //MARK: - Properties
    var model = FactsViewModel()
    var imageDownloadsInProgress: [DownloadManager] = []
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.shouldRefresh = true
        reloadButton.isEnabled = false
        SVProgressHUD.show()
    }
    
    override func didReceiveMemoryWarning() {
        cancellAllDownloads()
    }
    
    deinit {
        cancellAllDownloads()
    }
    
    //MARK: - IBActions
    @IBAction func reloadItems(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        reloadButton.isEnabled = false
        model.shouldRefresh = true
    }
    
    //MARK: - Helper methods
    /// For cancelling all downloads in progress
    func cancellAllDownloads() {
        for item in imageDownloadsInProgress {
            item.cancelDownload()
        }
        imageDownloadsInProgress.removeAll()
    }
}

// MARK: - UITableViewDataSource methods
extension FactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.facts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FactCell.reuseIdentifier, for: indexPath) as! FactCell
        
        let fact = model.facts[indexPath.row]
        
        cell.titleLabel.text = fact.title
        cell.descLabel.text = fact.description
        cell.factImageView.image = UIImage(named: "loading")
        
        return cell
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let indexPath = tableView.indexPathsForVisibleRows![0]
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
    }
}

// MARK: - UITableViewDelegate methods
extension FactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let fact = model.facts[indexPath.row]
        let downloadManager = DownloadManager(withFact: fact)
        imageDownloadsInProgress.append(downloadManager)
        downloadManager.downloadImage(at: indexPath) { (image, indexPathh, error) in
            if let indexPathNew = indexPathh {
                DispatchQueue.main.async {
                    if let getCell = tableView.cellForRow(at: indexPathNew) {
                        if let img = image {
                            (getCell as? FactCell)!.factImageView.image = img
                        } else {
                            (getCell as? FactCell)!.factImageView.image = UIImage(named: "imageError")
                        }
                        
                    }
                }
            }
        }
    }
    
}

// MARK: - FactsViewModelDelegate methods
extension FactsViewController: FactsViewModelDelegate {
    func fetchDidFail(with error: Error) {
        SVProgressHUD.dismiss()
        reloadButton.isEnabled = true
        showError(withError: error)
    }
    
    func fetchDidSucceed() {
        SVProgressHUD.dismiss()
        reloadButton.isEnabled = true
        tableView.reloadData()
        title = model.factsInfo?.title
    }
}
