//
//  ViewController.swift
//  kadaiApp005
//
//  Created by YoNa on 2020/11/17.
//

import UIKit

class ViewController: UIViewController,XMLParserDelegate,UITableViewDelegate,UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myTabBar: UITabBar!
    
    
    var titles:[String]=[]
    var links:[String]=[]
    var pubDate:[String]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // XMLURL
        let url_text = "https://news.yahoo.co.jp/rss/topics/world.xml"
        
        // URLが正しいかどうか判定　正しかったらurlに値が入る
        guard let url = NSURL(string: url_text)else{
            return
        }
        //  インターネット上のXMLを取得し、NSXMLParserに読み込む
        guard let parser = XMLParser(contentsOf: url as URL) else{
            return
        }
        // TabBarのボタンの色
        // 押されていないとき
        myTabBar.unselectedItemTintColor=UIColor.orange
        // 押されたとき
        myTabBar.tintColor=UIColor(red: 255.0/255.0, green: 0, blue: 0, alpha: 1)
        // TabBarのテキストの色

        for item in (myTabBar.items!){
            // 押されていないとき
//            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1)], for: UIControl.State.normal)
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0, alpha: 1)], for: UIControl.State.normal)
            // 押されたとき
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)], for: UIControl.State.selected)
        }
        
        parser.delegate = self
        parser.parse()
        tableView.dataSource = self
        tableView.delegate = self
        myTabBar.delegate = self
        
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // セルの内容を変更
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MySell",for: indexPath) as! MyCustomTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.linkLabel.text = links[indexPath.row]
        cell.pubDateLabel.text = pubDate[indexPath.row]
        return cell
    }
    
    
    // セルをタップすると動くメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: links[indexPath.row]){
            UIApplication.shared.open(url)
        }
    }
    
    //  XML解析開始時に実行されるメソッド
    func parserDidStartDocument(_ parser:XMLParser){
        print("XML解析開始しました")
    }
    
    
    
    var elementSring :String = ""
    var titleData:String = ""
    var linkData:String = ""
    var pubDateData:String = ""
    
    
    func parser(_ parser:XMLParser,didStartElement elementName: String,namespaceURI:String?,qualifiedName qName:String?,attributes attributeDict:[String: String]){
        elementSring = elementName
        // itemタグの中のtitleだけ集めるための荒技
        
        print("開始タグ:" + elementSring)
    }
    
    //  開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    
    
    func parser(_ parser:XMLParser,foundCharacters string:String){
        
        switch elementSring {
        case "title":
            print("要素:" + string)
            titleData = titleData + string
        case "link":
            print("要素:" + string)
            linkData = linkData + string
        case "pubDate":
            print("要素:" + string)
            
            // DateFomatterクラスのインスタンス生成
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
            
            /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
            
            // dateFormatter.dateFormat = "EEE, dd MM yyyy HH:mm:ss Z"
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            
            //print(dateString)   // "2020年4月25日(土) 16時8分56秒”
            
            /// データ変換（テキスト→Date）
            let date = dateFormatter.date(from: string)!
            
            dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            
            let outputString = dateFormatter.string(from: date)
            print(outputString)   // 2020-04-25 07:08:56 +0000
            pubDateData = pubDateData + outputString
        default: break
            
        }
    }
    
    
    //  解析中に要素の終了タグがあったときに実行されるメソッド
    func parser(_ parser:XMLParser,didEndElement elementName:String,namespaceURI:String?,qualifiedName qName:String?){
        print("終了タグ:" + elementName)

        switch elementSring {
        case "title":
            titles.append(titleData)
        case "link":
            links.append(linkData)
        case "pubDate":
            pubDate.append(pubDateData)
        default:break
        }

        titleData = ""
        linkData = ""
        pubDateData = ""
        elementSring = ""
        
    }
    //  XML解析終了時に実行されるメソッド
    func parserDidEndDocument(_ parser:XMLParser){
        titles.removeFirst()
        links.removeFirst()
        
        self.tableView.reloadData()
        
        print("XML解析終了しました")
    }
    //  解析中にエラーが発生した時に実行されるメソッド
    func parser(_ parser:XMLParser,parseErrorOccurred parseError:Error){
        print("エラー:" + parseError.localizedDescription)
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let url_text:String
        switch item.tag {
        case 0:
            url_text = "https://news.yahoo.co.jp/rss/topics/it.xml"
        case 1:
            url_text = "https://news.yahoo.co.jp/rss/topics/entertainment.xml"
        default:
            url_text = "https://news.yahoo.co.jp/rss/topics/top-picks.xml"
        }
        
        titles = []
        links = []
        pubDate = []
        
        //URLの記述が正しいかを判定。正しかったらurlに値が入る。
        guard let url = NSURL(string: url_text) else{
            return
        }
        
        // インターネット上のXMLを取得し、NSXMLParserに読み込む
        guard let parser = XMLParser(contentsOf: url as URL) else{
            return
        }
        
        parser.delegate = self;
        parser.parse() //解析開始
        
        tableView.dataSource = self
        tableView.delegate = self
        
        myTabBar.delegate = self
        
    }
    
}

