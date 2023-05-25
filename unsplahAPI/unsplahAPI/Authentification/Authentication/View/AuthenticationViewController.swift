//
//  AuthenticationViewController.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit
import Combine

class AuthenticationViewController: UIViewController, AuthenticationViewControllerProtocol {
    
    var coordinator: AuthentificationCoordinatorProtocol?
    var viewModel: AuthenticationViewModelProtocol?
    var userCancelable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

       userCancelable = viewModel?.user.$authenticationState.sink { [weak self] autheticationState in
            switch autheticationState {
            case .unauthenticated:
                //TODO: show auth screen
                self?.authenticationProcess(result: .failure(AuthenticationErrors.unableToIdentifyUser))
            case .authenticated:
                self?.authenticationProcess(result: .success(self?.viewModel?.user))
            case .authenticating:
                //TODO: perform default process
                print(autheticationState)
            }
        }
    }
    
    func authenticationProcess(result: Result <User?, Error>) {
        switch result {
        case .success(let user):
            coordinator?.didFinishAuthentification()
        case .failure(let error):
            self.constructView()
            print(error.localizedDescription)
        }
    }
    
    private func constructView() {
        self.view.backgroundColor = .red
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userCancelable = nil
    }
}
