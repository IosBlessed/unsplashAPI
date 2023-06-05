//
//  PictureDetailsViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit
import SDWebImage

class PictureDetailsViewController: UIViewController, PictureDetailsViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var imageScrollView: UIScrollView!
    @IBOutlet private weak var selectedImageView: UIImageView!
    // MARK: - Properties
    var viewModel: PictureDetailsViewModelProtocol!
    private var imageObject: UnsplashImage!
    // MARK: - UI Properties
    private var activityIndicator: UIActivityIndicatorView!
    private var viewForImageDetails: UIView!
    private var centralViewForLikeAnimation: UIImageView!
    private var centralViewForLikeHeightAnchor: NSLayoutConstraint!
    private var centralViewForLikeWidthAnchor: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignedSystemColors.primary
        setupNavigationSection()
        setupSelectedImageView()
        setupViewForImageDetails()
        setupActivityIndicatorView()
        setupAnimationForLike()
        setupImageScrollView()
        setupConstraints()
        setupBindings()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectedImageView.frame = imageScrollView.frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForImageDetails.layer.sublayers!.first!.frame = viewForImageDetails.bounds
    }
    
    //MARK: - Behaviour
    private func setupNavigationSection() {
        self.tabBarController?.tabBar.isHidden = true
        let likeButton = UIBarButtonItem.createRightBarButton(
            target: self,
            action: #selector(likeImage),
            imageSystemName: "heart"
        )
        navigationItem.rightBarButtonItem = likeButton
    }
    
    private func setupSelectedImageView() {
        selectedImageView.contentMode = .scaleAspectFill
        selectedImageView.layer.masksToBounds = true
        addLikeGestureRecognizer()
    }
    
    private func setupViewForImageDetails() {
        viewForImageDetails = UIView(frame: .zero)
        viewForImageDetails.translatesAutoresizingMaskIntoConstraints = false
        viewForImageDetails.backgroundColor = .clear
        viewForImageDetails.isHidden = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        viewForImageDetails.layer.addSublayer(gradientLayer)
        view.addSubview(viewForImageDetails)
    }
    
    private func setupActivityIndicatorView() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        selectedImageView.addSubview(activityIndicator)
    }
    
    private func setupAnimationForLike() {
        centralViewForLikeAnimation = UIImageView(image: UIImage(systemName: "heart.fill")!)
        centralViewForLikeAnimation.tintColor = .white
        centralViewForLikeAnimation.translatesAutoresizingMaskIntoConstraints = false
        centralViewForLikeAnimation.isHidden = true
        view.addSubview(centralViewForLikeAnimation)
    }
    
    private func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 8.0
        imageScrollView.delegate = self
        imageScrollView.backgroundColor = .clear
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupConstraints() {
        imageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -150).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -50
        ).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: Constants.likeHeartAnimationSize.height).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: Constants.likeHeartAnimationSize.width).isActive = true
        
        centralViewForLikeAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centralViewForLikeAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centralViewForLikeWidthAnchor = centralViewForLikeAnimation.widthAnchor.constraint(equalToConstant: 100)
        centralViewForLikeHeightAnchor = centralViewForLikeAnimation.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([centralViewForLikeWidthAnchor, centralViewForLikeHeightAnchor])
        
        viewForImageDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewForImageDetails.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -100).isActive = true
        viewForImageDetails.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
    }
    
    private func setupBindings() {
        viewModel.isLiked.bind { [weak self] isLiked in
            guard let self else { return }
            let imageLike = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            (self.navigationItem.rightBarButtonItem?.customView as! UIButton).setBackgroundImage(imageLike, for: .normal)
        }
    }
    
    private func addLikeGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeImage))
        tapGestureRecognizer.numberOfTapsRequired = 2
        imageScrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func initializeImageSetup(image: UnsplashImage) {
        self.imageObject = image
        setupImage { data, _ in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.selectedImageView.image = UIImage(data: data)
                self.viewForImageDetails.isHidden = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupImage(completion: @escaping(Data?, Error?) -> Void) {
        let backgroundTask = DispatchQueue.global(qos: .background)
        backgroundTask.async { [weak self] in
            guard let self else { return }
            do {
                let imageData = try Data(contentsOf: URL(string: self.imageObject.urls.full)!)
                return completion(imageData, nil)
            } catch let error as NSError {
                return completion(nil, error)
            }
        }
    }
    
    // MARK: - Animations
    private func performImageAnimation() {
        centralViewForLikeAnimation.isHidden = false
        UIView.animate(
            withDuration: 0.5,
            animations: ({ [weak self] in
            guard let self
            else { return }
                self.centralViewForLikeAnimation.layer.opacity = 1.0
                self.centralViewForLikeWidthAnchor.constant = 150
                self.centralViewForLikeHeightAnchor.constant = 120
                self.view.layoutSubviews()
            })
        ) { [weak self] finished in
            guard let self else { return }
            UIView.animate(withDuration: 1.0) {
                self.centralViewForLikeAnimation.layer.opacity = 0.0
                self.centralViewForLikeWidthAnchor.constant = Constants.likeHeartAnimationSize.width
                self.centralViewForLikeHeightAnchor.constant = Constants.likeHeartAnimationSize.height
                self.view.layoutSubviews()
            }
        }
    }
    
    // MARK: - Objc
    @objc private func likeImage() {
        // viewModel should process if button tapped
        performImageAnimation()
        viewModel.likeButtonTapped()
    }
}

extension PictureDetailsViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImageView
    }
}
