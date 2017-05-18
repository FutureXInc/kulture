//
//  PostViewController.swift
//  Kulture
//
//  Created by bis on 5/13/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse

protocol PostDelegate: class {
    func contentRequestFullfilled(contentRequest: PFObject, postId: String)
}


class PostViewController: UIViewController, UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate, VideoSelectorDelegate {

    var videoUrl: String?
    var postImage: UIImage?
    var contentRequest: PFObject?
    weak var delegate: PostDelegate?
    
    @IBOutlet weak var sendImage: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImgButton: UIButton!
    @IBOutlet weak var cameraImgButton: UIButton!
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var videoWebViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(onSendTap))
        self.sendImage.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   func onSendTap() {
        var postType: PostType = .Text
        if videoUrl != nil {
            postType = .Video
        }
        else if postImage != nil {
            postType = .Image
        }
        API.sharedInstance.savePost(
            postType: postType, caption: captionTextField.text!,
            kidUserId: contentRequest?["kidUserId"] as! String,
            parentUserId: contentRequest?["parentId"] as! String,
            text: messageTextView.text, image: postImage, videoId: videoUrl,
            successFunc: { (postId: String) in
                self.delegate?.contentRequestFullfilled(
                    contentRequest: self.contentRequest!,
                    postId: postId)
            })
        { (error: Error) in
            print("\(error)")
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onImageTap(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true) {
            self.postImage = originalImage
            self.postImageView.image = originalImage
            self.postImageViewHeightConstraint.constant = 250
            self.maybeToggleButtonImage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! VideoSelectorViewController
        destinationVC.delegeate = self
        destinationVC.beginUrl = videoUrl ?? "http://youtube.com"
    }
    
    func selectedVideoUrl(url: String?) {
        navigationController?.popViewController(animated: true)
        if (url != nil && url!.range(of: "watch?v=") != nil) {
            videoUrl = url?.replacingOccurrences(of: "watch?v=", with: "embed/")
            videoUrl = videoUrl?.replacingOccurrences(of: "m.youtube", with: "youtube")
            videoWebView.loadRequest(URLRequest(url: URL(string: videoUrl!)!))
            videoWebViewHeightConstraint.constant = 200
        } else {
            videoUrl = nil
            videoWebViewHeightConstraint.constant = 0
        }
        maybeToggleButtonImage()
    }

    func maybeToggleButtonImage() {
        videoImgButton.setImage(videoUrl == nil ? #imageLiteral(resourceName: "videoEmpty") : #imageLiteral(resourceName: "videoSelected"),
                                for: UIControlState.normal)
        cameraImgButton.setImage(postImage == nil ? #imageLiteral(resourceName: "cameraEmpty"): #imageLiteral(resourceName: "cameraSelected"),
                                 for: UIControlState.normal)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.footerViewYConstraint.constant = 0
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.2) {
            self.footerViewYConstraint.constant = frame.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(_:)),
            name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(_:)),
            name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
