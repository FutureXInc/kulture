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


class  ContentApprovalViewController: UIViewController, UITableViewDataSource,
                                      UITableViewDelegate, ContentCellDelegate {

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
        let kidUserId = "W0N0zgWm47"
        print ("this is the kid user id \(kidUserId)")
        
        let predicate = NSPredicate.init(format: "objectId ==[c] %@", kidUserId)
        
        API.sharedInstance.fetchKidWithID(predicate: predicate, successFunc: { (kidReturned: PFObject?) in
            print ("Kid name is \(kidReturned?["username"])")
        }) { (Error) in
            
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.posts[indexPath.section]
        let type = PostType(rawValue: post["postType"]! as! Int)!
        switch type {
        case PostType.Text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTextCell",
                                                     for: indexPath) as! ContentTextCell
            cell.post = post
            cell.delegate = self
            return cell
        case PostType.Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentImageCell",
                                                     for: indexPath) as! ContentImageCell
            cell.backgroundColor = UIColor.lightGray
            cell.post = post
            cell.delegate = self
            return cell
        case PostType.Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentVideoCell",
                                                     for: indexPath) as! ContentVideoCell
            cell.post = post
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentImageCell",
                                                     for: indexPath) as! ContentImageCell
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

    func contentApprovalChanged(post: PFObject, approved: Bool) {
        API.sharedInstance.changePostApproval(post: post, approved: approved)
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
        DataManager.sharedInstance.getUnapprovedPosts()
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


protocol ContentCellDelegate: class {
    func contentApprovalChanged(post: PFObject, approved: Bool)
}


class ContentImageCell: UITableViewCell {

    @IBOutlet weak var contentImage: PFImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!

    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var view: UIView!
    
    weak var delegate: ContentCellDelegate?
    var isLiked: Bool!
    
    var post: PFObject! {
        didSet {
            agentName.text = (post["familyMemberId"] as! String)
            //agbB9SnLyX
            
            //let kidUserId = (post["kidUserId"] as! String)
//            let kidUserId = "agbB9SnLyX"
//            print ("this is the kid user id \(kidUserId)")
//            
//            let predicate = NSPredicate.init(format: "kidUserId ==[c] %@", kidUserId)
//            
//            API.sharedInstance.fetchKidWithID(predicate: predicate, successFunc: { (kidReturned: PFObject?) in
//                print ("Kid name is \(kidReturned?["username"])")
//            }) { (Error) in
//                
//            }
            
            tags.text = " #"+(post["tag"] as? String)!
            let img = post["image"] as! PFFile
            contentImage.file = img
            contentImage.loadInBackground()
            isLiked = post["approvalState"] as! Bool
            self.setApprovalState()
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
        self.view.insertSubview(blurEffectView, at: 0)

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(likeTapped))
        self.likeImg.addGestureRecognizer(gesture)
    }

    func likeTapped() {
        self.isLiked = !self.isLiked
        self.setLikeState()
        delegate?.contentApprovalChanged(post: self.post, approved: isLiked)
    }
    
    func setApprovalState() {
        if self.isLiked {
            likeImg.image = #imageLiteral(resourceName: "Checked")
        }
        else {
            likeImg.image = #imageLiteral(resourceName: "Check")
        }
    }

}

class ContentTextCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    weak var delegate: ContentCellDelegate?
    var isLiked: Bool!

    @IBOutlet weak var tags: UILabel!

    var post: PFObject! {
        didSet {
            agentName.text = "Loki"
            let contentx = post["text"] as! String
            content.text = contentx
            tags.text =  " #"+(post["tag"] as? String)!
            isLiked = post["approvalState"] as? Bool ?? false
            setApprovalState()
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
        self.isLiked = !self.isLiked
        self.setApprovalState()
        delegate?.contentApprovalChanged(post: self.post, approved: isLiked)
    }
    
    func setApprovalState() {
        if self.isLiked {
            likeImg.image = #imageLiteral(resourceName: "Checked")
        }
        else {
            likeImg.image = #imageLiteral(resourceName: "Check")
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
    var isLiked: Bool!
    weak var delegate: ContentCellDelegate?
    
    var post: PFObject! {
        didSet {
            agentName.text = "Alex"
            tags.text = " #"+(post["tag"] as? String)!
            let id = post["videoId"] as! String
            loadYoutube(videoID: id)
            isLiked = post["approvalState"] as! Bool
            setApprovalState()
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

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(likeTapped))
        self.likeImg.addGestureRecognizer(gesture)
    }
    
    func likeTapped() {
        self.isLiked = !self.isLiked
        self.setApprovalState()
        delegate?.contentApprovalChanged(post: self.post, approved: isLiked)
    }
    
    func setApprovalState() {
        if self.isLiked {
            likeImg.image = #imageLiteral(resourceName: "Checked")
        }
        else {
            likeImg.image = #imageLiteral(resourceName: "Check")
        }
    }
}
