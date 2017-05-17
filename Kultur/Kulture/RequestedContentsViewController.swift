//
//  RequestedContentsViewController.swift
//  Kulture
//
//  Created by bis on 5/13/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse


protocol RequestedContentsViewModelDelegate: class {
    func dataIsReady()
}


class RequestedContentsViewModel: DataManagerListener {
    
    var contentRequests: [PFObject]!
    weak var delegate: RequestedContentsViewModelDelegate?
    
    init(){
        DataManager.sharedInstance.delegate = self
    }
    
    func fetch() {
        DataManager.sharedInstance.getContentRequests()
    }
    
    func finishedFetchingData(result: Result) {
        switch result {
        case .Failure(let error):
            print("found \(error)")
        case .Success(let contentRequests):
            self.contentRequests = contentRequests
            print("\(contentRequests)")
            delegate?.dataIsReady()
        }
    }
}

class RequestedContentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                                       RequestedContentsViewModelDelegate, PostDelegate {

    @IBOutlet weak var requestdContentTableView: UITableView!
    var viewModel: RequestedContentsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestdContentTableView.delegate = self
        requestdContentTableView.dataSource = self
        requestdContentTableView.estimatedRowHeight = 250
        requestdContentTableView.rowHeight = UITableViewAutomaticDimension
        viewModel = RequestedContentsViewModel()
        viewModel.delegate = self
        viewModel.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dataIsReady() {
        requestdContentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestdContentTableView.dequeueReusableCell(
            withIdentifier: "RequestedContentTableViewCell",
            for: indexPath) as! RequestedContentTableViewCell
        cell.contentRequest = viewModel.contentRequests[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contentRequests?.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let postVC = segue.destination as! PostViewController
        let idx = requestdContentTableView.indexPathForSelectedRow!.section
        postVC.contentRequest = viewModel.contentRequests[idx]
        postVC.delegate = self
    }
    
    func contentRequestFullfilled(contentRequest: PFObject, postId: String) {
        navigationController!.popViewController(animated: true)
        contentRequest["postId"] = postId
        contentRequest.saveInBackground()
        viewModel.fetch()
    }
}
