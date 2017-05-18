//
//  TimeLineViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import ParseUI
import FTIndicator


class  TimeLineViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, TimeLineCellDelegate {

    private var timeLineViewModel: TimeLineViewModel?

    var displayingContentFor: User? = nil

    @IBOutlet weak var tableView: UITableView!
    var filter: Filter!

    var viewModel: TimeLineViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        viewModel = TimeLineViewModel()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTextCell",
                                                     for: indexPath) as! TimeLineTextCell
            cell.post = post
            cell.delegate = self
            return cell
        case PostType.Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineImageCell",
                                                     for: indexPath) as! TimeLineImageCell
            cell.backgroundColor = UIColor.lightGray
            cell.post = post
            cell.delegate = self
            return cell
        case PostType.Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineVideoCell",
                                                     for: indexPath) as! TimeLineVideoCell
            cell.post = post
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineImageCell",
                                                     for: indexPath) as! TimeLineImageCell
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

    func showProfile(user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "user_profile_view_controller") as! UserProfileViewController
        pvc.user = user
        self.show(pvc, sender: nil)
    }
}

extension TimeLineViewController: TimeLineViewDelegate {

    func dataIsReady() {
        tableView.reloadData()
        FTIndicator.dismissProgress()
    }
}



protocol TimeLineViewDelegate {
    func dataIsReady()
}

class TimeLineViewModel: DataManagerListener {

    var posts: [PFObject]!
    var delegate: TimeLineViewDelegate?

    init(){
        DataManager.sharedInstance.delegate = self
    }

    func fetch(filter: Filter) {
        DataManager.sharedInstance.getPostsForParent()
    }

    func finishedFetchingData(result: Result) {
        switch result {
        case .Failure(let error):
            print("####### ERROR ##### \(error)")
        case .Success(let posts):
            self.posts = posts
            delegate?.dataIsReady()
        }
    }

}


protocol TimeLineCellDelegate: class {
    func contentApprovalChanged(post: PFObject, approved: Bool)
    func showProfile(user: User)
}



class TimeLineImageCell: UITableViewCell {

    @IBOutlet weak var contentImage: PFImageView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!

    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var view: UIView!

    weak var delegate: TimeLineCellDelegate?
    var isLiked: Bool!
    var author: User!

    var post: PFObject! {
        didSet {
            agentName.text = (post["familyMemberId"] as! String)


            tags.text = " #"+(post["tag"] as? String)!
            let img = post["image"] as! PFFile
            contentImage.file = img
            contentImage.loadInBackground()
            isLiked = post["approvalState"] as! Bool
            self.setApprovalState()
            let familyMemberId = post["familyMemberId"] as! String
            author = UserCache.sharedInstance.getUser(familyMemberId)
            let kidUserId = post["kidUserId"] as! String
            let kid = UserCache.sharedInstance.getUser(kidUserId)

            let aname = API.sharedInstance.toUpperCase((author?.firstName)!)
            let kname = API.sharedInstance.toUpperCase((kid?.firstName)!)

            agentName.text = "\(aname) shared a picture for \(kname)"
            avatar.setImageWith((author?.profileImageURL)!)
            avatar.layer.cornerRadius = avatar.frame.width / 2.0
            avatar.layer.masksToBounds = true
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

        let gesture1 = UITapGestureRecognizer()
        gesture1.addTarget(self, action: #selector(showProfile))
        self.avatar.addGestureRecognizer(gesture1)
    }

    func showProfile() {
        delegate?.showProfile(user: author)
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

class TimeLineTextCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var avatar: PFImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    weak var delegate: TimeLineCellDelegate?
    var isLiked: Bool!
    var author: User!

    @IBOutlet weak var tags: UILabel!

    var post: PFObject! {
        didSet {
            agentName.text = "Loki"
            let contentx = post["text"] as! String
            content.text = contentx
            tags.text =  " #"+(post["tag"] as? String)!
            isLiked = post["approvalState"] as? Bool ?? false
            setApprovalState()

            let familyMemberId = post["familyMemberId"] as! String
            author = UserCache.sharedInstance.getUser(familyMemberId)
            let kidUserId = post["kidUserId"] as! String
            let kid = UserCache.sharedInstance.getUser(kidUserId)
            let aname = API.sharedInstance.toUpperCase((author?.firstName)!)
            let kname = API.sharedInstance.toUpperCase((kid?.firstName)!)

            agentName.text = "\(aname) shared a story for \(kname)"
            avatar.setImageWith((author?.profileImageURL)!)
            avatar.layer.cornerRadius = avatar.frame.width / 2.0
            avatar.layer.masksToBounds = true
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

        let gesture1 = UITapGestureRecognizer()
        gesture1.addTarget(self, action: #selector(showProfile))
        self.avatar.addGestureRecognizer(gesture1)
    }

    func showProfile() {
        delegate?.showProfile(user: author)
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

class TimeLineVideoCell: UITableViewCell {

    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var content: UIWebView!
    @IBOutlet weak var avatar: PFImageView!

    @IBOutlet weak var tags: UILabel!
    var author: User!
    var isLiked: Bool!
    weak var delegate: TimeLineCellDelegate?

    var post: PFObject! {
        didSet {
            agentName.text = "Alex"
            tags.text = " #"+(post["tag"] as? String)!
            let id = post["videoId"] as! String
            loadYoutube(videoID: id)
            isLiked = post["approvalState"] as! Bool
            setApprovalState()

            let familyMemberId = post["familyMemberId"] as! String
            author = UserCache.sharedInstance.getUser(familyMemberId)
            let kidUserId = post["kidUserId"] as! String
            let kid = UserCache.sharedInstance.getUser(kidUserId)

            let aname = API.sharedInstance.toUpperCase((author?.firstName)!)
            let kname = API.sharedInstance.toUpperCase((kid?.firstName)!)

            agentName.text = "\(aname) shared a video for \(kname)"
            avatar.setImageWith((author?.profileImageURL)!)

            avatar.layer.cornerRadius = avatar.frame.width / 2.0
            avatar.layer.masksToBounds = true
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

        let gesture1 = UITapGestureRecognizer()
        gesture1.addTarget(self, action: #selector(showProfile))
        self.avatar.addGestureRecognizer(gesture1)
    }

    func showProfile() {
        delegate?.showProfile(user: author)
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

