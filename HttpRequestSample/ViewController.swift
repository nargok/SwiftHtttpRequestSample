//
//  ViewController.swift
//  HttpRequestSample
//
//  Created by 後閑諒一 on 2017/08/05.
//  Copyright © 2017年 ryoichi.gokan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var json:NSData!

    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.lightGray
        
//        self.view.addSubview(resultTextView)
        
        // dictionaryで送信するJSONデータを生成
        
        let myDict:NSMutableDictionary = NSMutableDictionary()
        myDict.setObject("object1", forKey: "key1" as NSCopying)
        myDict.setObject("object2", forKey: "key2" as NSCopying)
        myDict.setObject("object3", forKey: "key3" as NSCopying)
        myDict.setObject("object4", forKey: "key4" as NSCopying)
        
        // 作成したdictionaryがJSONに変換可能かチェック
        if JSONSerialization.isValidJSONObject(myDict) {
            
            do {
                // DictionaryからJSON(NSData)へ変換
                json = try JSONSerialization.data(withJSONObject: myDict, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
                
                // 生成したJSONデータの確認
                print(NSString(data: json as Data, encoding: String.Encoding.utf8.rawValue)!)
            } catch {
                print(error)
            }
            
        }
        
        // Http通信のリクエスト生成
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        let url:NSURL = NSURL(string: "http://xxxxxxx/json_decode.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        let session:URLSession = URLSession(configuration: config)
        
        request.httpMethod = "POST"
        
        // jsonデータを一度文字列にしてキーとあわせる
        let data:NSString = "json=\(NSString(data: json as Data, encoding: String.Encoding.utf8.rawValue)!)" as NSString
        
        // jsonデータのセット
        request.httpBody = data.data(using: String.Encoding.utf8.rawValue)
        
        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (_data, response, err) -> Void in
            
        // バックグラウンドだとUIの処理ができないので、メインスレッドでUIの処理を行わせる。
            DispatchQueue.main.async(execute: {
                self.resultTextView.text = NSString(data: _data!, encoding: String.Encoding.utf8.rawValue)! as String
            })
            
        })
        
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

