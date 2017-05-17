//
//  ContentApprovalViewController.swift
//  Kulture
//
//  Created by Pattanashetty, Sadananda on 5/16/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//


import UIKit
import Parse
import AFNetworking
import ParseUI
import FTIndicator


class  ContentApprovalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    var filter: Filter!

    var viewModel: ContentApprovalViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        viewModel = ContentApprovalViewModel()
        FTIndicator.showProgressWithmessage("Loading...", userInteractionEnable: false)
        viewModel.delegate = self

        if let filter = filter {
            viewModel.fetch(filter: filter)
        }
        else {
            viewModel.fetch(filter: .latest)

        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.posts[indexPath.section]
        let type = post["postType"]! as! Int16

        switch type {

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTextCell", for: indexPath) as! ContentTextCell
            cell.post = post
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentImageCell", for: indexPath) as! ContentImageCell
            cell.post = post
            cell.backgroundColor = UIColor.lightGray
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentVideoCell", for: indexPath) as! ContentVideoCell
            cell.post = post
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentImageCell", for: indexPath) as! ContentImageCell
            return cell
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.posts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        return 10
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        if section != 0 {
            let lineView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(4), width: CGFloat(view.bounds.size.width), height: CGFloat(1.2)))
            lineView.backgroundColor = UIColor.darkGray
            headerView.addSubview(lineView)
        }
        return headerView
    }




}

extension ContentApprovalViewController: ContentApprovalViewDelegate {

    func dataIsReady() {
        tableView.reloadData()
        FTIndicator.dismissProgress()
    }
}



protocol ContentApprovalViewDelegate {
    func dataIsReady()
}

class ContentApprovalViewModel: DataManagerListener {

    var posts: [PFObject]!
    var delegate: ContentApprovalViewDelegate?

    init(){
        DataManager.sharedInstance.delegate = self
    }

    func fetch(filter: Filter) {
        DataManager.sharedInstance.getPosts(filter: filter)
    }

    func finishedFetchingData(result: Result) {
        switch result {
        case .Failure(let error):
            print("####### ERROR ##### \(error)")

        case .Success(let posts):
            //            self.posts = posts.filter({ (post) -> Bool in
            //                return (post["postType"]! as! Int16) != 3
            //            })

            self.posts = posts

            delegate?.dataIsReady()
        }
    }

}


class ContentImageCell: UITableViewCell {

    @IBOutlet weak var contentImage: PFImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!

    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var view: UIView!

    var post: PFObject! {
        didSet {
            agentName.text = "Sada"
            tags.text = " #"+(post["tag"] as? String)!
            let img = post["image"] as! PFFile
            contentImage.file = img
            contentImage.loadInBackground()
            let isLiked = post["isLiked"] as! Bool

            if isLiked {
                likeImg.image = #imageLiteral(resourceName: "Checked")
            }
            else {
                likeImg.image = #imageLiteral(resourceName: "Check")
            }

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = UIColor.clear

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)

    }
}

class ContentTextCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    var isLiked: Bool = false

    @IBOutlet weak var tags: UILabel!

    var post: PFObject! {
        didSet {
            agentName.text = "Loki"
            let contentx = post["text"] as! String
            content.text = contentx
            tags.text =  " #"+(post["tag"] as? String)!

            isLiked = post["isLiked"] as? Bool ?? false

            if isLiked {
                likeImg.image = #imageLiteral(resourceName: "Checked")
            }
            else {
                likeImg.image = #imageLiteral(resourceName: "Check")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.view.backgroundColor = UIColor.clear

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.insertSubview(blurEffectView, at: 0)

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(likeTapped))
        self.likeImg.addGestureRecognizer(gesture)

    }

    func likeTapped() {
        if isLiked {
            likeImg.image = #imageLiteral(resourceName: "Check")
        }
        else {
            likeImg.image  = #imageLiteral(resourceName: "Checked")

        }
    }

}

class ContentVideoCell: UITableViewCell {

    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var content: UIWebView!
    @IBOutlet weak var avatar: PFImageView!

    @IBOutlet weak var tags: UILabel!

    var post: PFObject! {
        didSet {
            agentName.text = "Alex"
            tags.text = " #"+(post["tag"] as? String)!
            let id = post["videoId"] as! String
            loadYoutube(videoID: id)
            let isLiked = post["isLiked"] as! Bool

            if isLiked {
                likeImg.image = #imageLiteral(resourceName: "Checked")
            }
            else {
                likeImg.image  = #imageLiteral(resourceName: "Check")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.backgroundColor = UIColor.clear

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?controls=0")
            else { return }
        content.loadRequest( URLRequest(url: youtubeURL) )
    }
    
    
    
}
