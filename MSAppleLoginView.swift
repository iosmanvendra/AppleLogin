//
//  MSAppleLoginView.swift
//  AppleLogin
//
//  Created by Manvendra on 16/12/19.
//  Copyright © 2019 Manvendra. All rights reserved.
//

import UIKit
import AuthenticationServices

typealias MSAuthorizeData = (appleId: String, userEmail: String?, userName: PersonNameComponents?)
protocol MSAppleLoginDelegate: class {
    func fialedToAuthorize(error: Error)
    func authorize(with data: MSAuthorizeData)
}
class MSAppleLoginView: UIView {
    @IBInspectable var darkStyle: Bool = true
    @IBInspectable var signInText: Bool = true
    weak var delegate: MSAppleLoginDelegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSignInAppleButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSignInAppleButton()
    }
    func setUpSignInAppleButton() {
        let style: ASAuthorizationAppleIDButton.Style = darkStyle ? .black : .white
        let appleIDButtonType: ASAuthorizationAppleIDButton.ButtonType = signInText ? .signIn : .continue
        let authorizationButton = ASAuthorizationAppleIDButton(type: appleIDButtonType, style: style)
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        authorizationButton.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(authorizationButton)
    }
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}
extension MSAppleLoginView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let authorize: MSAuthorizeData = (userIdentifier, email, fullName)
            delegate?.authorize(with: authorize)
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.fialedToAuthorize(error: error)
    }
}
