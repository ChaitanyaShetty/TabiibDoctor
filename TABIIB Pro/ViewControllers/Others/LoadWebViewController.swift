//
//  LoadWebViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class LoadWebViewController: CommonViewController,UIWebViewDelegate {
    
    @IBOutlet weak var lblOfTitle : UILabel!
    @IBOutlet weak var webView : UIWebView!
    
    var viewtoLoad : String! = ""
    
    let aboutUsUrl = "https://www.tabiib.com/about-us"
    let termsCondiUrl = "https://www.tabiib.com/terms-and-conditions"
    let privacyUrl = "https://www.tabiib.com/privacy-policy"
    let faqsUrl = "https://www.tabiib.com/faqs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        
        loadWebView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebView(){
        //1 : faq, 2 : privacy, 3: terms condi , 4: About
        // arrofOptions = ["FAQ’s","Privacy Policy","Terms & Conditions","About us","Rate our app","Email us","Contact us"]
        // APIServices.SharedInstance.MbProgress(view: self.view, Message: JumanConstants.LoaderMessages.RetEvent)
        
        if viewtoLoad == "1" {
            
            let faq = NSLocalizedString("FAQ’s", comment: "")
            
            lblOfTitle.text = faq
            let urlRequest = URLRequest.init(url:URL.init(string:  faqsUrl)!)
            webView.loadRequest(urlRequest)
        }
        else if viewtoLoad == "2" {
            let privacy = NSLocalizedString("PRIVACY POLICY", comment: "")
            lblOfTitle.text = privacy
            let urlRequest = URLRequest.init(url:URL.init(string:  privacyUrl)!)
            webView.loadRequest(urlRequest)
        }
        else if viewtoLoad == "3" {
            let tc = NSLocalizedString("T & C", comment: "")
            lblOfTitle.text = tc
            let urlRequest = URLRequest.init(url:URL.init(string:  termsCondiUrl)!)
            webView.loadRequest(urlRequest)
        }
        else if viewtoLoad == "4" {
            let about = NSLocalizedString("About us", comment: "")
            lblOfTitle.text = about
            let urlRequest = URLRequest.init(url:URL.init(string:  aboutUsUrl)!)
            webView.loadRequest(urlRequest)
        }
    }
    
    
    //    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    //
    //         self.hideActivityIndicator()
    //
    //    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hideActivityIndicator()
    }
    func webViewDidStartLoad(_ webView: UIWebView){
        self.showActivityIndicator()
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
        self.hideActivityIndicator()
        
        //hide loader
        // APIServices.SharedInstance.hideProgress()
        
    }
    
    @IBAction func backBtnClicked(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
