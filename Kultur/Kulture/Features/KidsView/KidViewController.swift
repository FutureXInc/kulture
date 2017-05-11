//
//  KidViewController.swift
//  Kulture
//
//  Created by Pattanashetty, Sadananda on 5/10/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import ParseUI


class KidViewController: UIViewController, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!

    var viewModel: KidViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        viewModel = KidViewModel()
        viewModel.delegate = self
        viewModel.fetch()
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KidImageCell", for: indexPath) as! KidImageCell
        let post = viewModel.posts[indexPath.row]
        cell.post = post
        return cell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts?.count ?? 0
    }



}

extension KidViewController: KidViewModelDelegate {

    func dataIsReady() {
        tableView.reloadData()
    }
}










protocol KidViewModelDelegate {
    func dataIsReady()
}

class KidViewModel: DataManagerListener {

    var posts: [PFObject]!
    var delegate: KidViewModelDelegate?

    init(){
        DataManager.sharedInstance.delegate = self
    }

    func fetch() {
      DataManager.sharedInstance.getPosts()
    }

    func finishedFetchingData(result: Result) {
        switch result {
        case .Failure(let error):
            print("####### ERROR ##### \(error)")

        case .Success(let posts):
            self.posts = posts.filter({ (post) -> Bool in
                return (post["postType"]! as! Int16) == 2
            })

            delegate?.dataIsReady()

        }

    }


}


class KidImageCell: UITableViewCell {

    @IBOutlet weak var contentImage: PFImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!

    var post: PFObject! {
        didSet {
            agentName.text = "Sada"
            let img = post["image"] as! PFFile
            contentImage.file = img
            contentImage.loadInBackground()
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


