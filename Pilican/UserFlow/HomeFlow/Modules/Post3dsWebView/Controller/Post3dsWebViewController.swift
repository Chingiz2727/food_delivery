import UIKit
import WebKit
import SafariServices

final class Post3dsWebViewController: UIViewController, Post3dsWebViewModule, WKNavigationDelegate, WKUIDelegate  {
    
    private let webView = WKWebView()
    var onCardAddTryed: OnCardAddTryed?
    private let bindCardModel: BindCardModel
    private let htmlString: String
    private let sessionStorage: UserSessionStorage
    private var paRes: String?
    private var Md: String?
    
    init(bindCardModel: BindCardModel, htmlString: String, sessionStorage: UserSessionStorage ) {
        self.bindCardModel = bindCardModel
        self.htmlString = htmlString
        self.sessionStorage = sessionStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.accessibilityNavigationStyle = .combined
        makeRequest()

    }
    
    private func makeRequest() {
        guard let url = URL(string: bindCardModel.acsUrl ?? "") else { return }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        // swiftlint:disable line_length
        let requestBody = String.init(format: "MD=%@&PaReq=%@&TermUrl=%@", "\(bindCardModel.mD ?? 0)", bindCardModel.paReq ?? "","https://demo.cloudpayments.ru/WebFormPost/GetWebViewData").replacingOccurrences(of: "+", with: "%2B")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        urlRequest.httpBody = requestBody.data(using: .utf8,allowLossyConversion: false)
        
        webView.load(urlRequest)
    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.getElementById('MD').value", completionHandler: { (value: Any!, error: Error!) -> Void in
            if let value = value {
                print(value)
                self.Md = "\(value)"
            }
        })
        
        webView.evaluateJavaScript("document.getElementById('PaRes').value", completionHandler: { (value: Any!, error: Error!) -> Void in
            if let value = value {
                print(value)
                self.paRes = "\(value)"
            }
        })
        webView.evaluateJavaScript("document.getElementsByName('PaRes')[0].value") { (result, error) in
            if let value = result {
                print(value)
                self.paRes = "\(value)"
                }
            }
        
        webView.evaluateJavaScript("document.getElementsByName('MD')[0].value") { (result, error) in
            if let value = result {
                print(value)
                self.Md = "\(value)"
                }
            }
        makeFinalRequst()
    }
   
    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        webView.evaluateJavaScript("document.getElementById('MD').value", completionHandler: { (value: Any!, error: Error!) -> Void in
            if let value = value {
                print(value)
                self.Md = "\(value)"
            }
        })
        
        webView.evaluateJavaScript("document.getElementById('PaRes').value", completionHandler: { (value: Any!, error: Error!) -> Void in
            if let value = value {
                print(value)
                self.paRes = "\(value)"
            }
        })
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        completionHandler(.performDefaultHandling, nil)
    }
    
    private func makeFinalRequst() {
        guard let paRes = paRes, let md = Md, let callId = bindCardModel.threeDsCallbackId else { return }
        let fullView = UIView()
        fullView.backgroundColor = .white
        view.addSubview(fullView)
        fullView.snp.makeConstraints { $0.edges.equalToSuperview() }
        ProgressView.instance.show(.loading, animated: true)
        MoyaApiService.shared.post3Ds(transactionId: md, threeDsCallbackId: callId, paRes: paRes, token: sessionStorage.accessToken ?? "" ) { (res, err) in
            ProgressView.instance.hide(animated: true)
            if let status = res {
                self.onCardAddTryed?(status)
            }
        }
    }
    
    
    private func addWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension Post3dsWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        print(message.name)
    }
}

