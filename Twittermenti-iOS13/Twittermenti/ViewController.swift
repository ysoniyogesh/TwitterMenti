//consumerKey: "qC5rSibjSOacnJzyf37yzXLIQ",
//consumerSecret: "sUDedN5F4BFEyBs9serNnC9WFDIzqRaqPtb9Uj3ZZXX0nglWi0"
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Swifter
import CoreML
import SwiftyJSON



class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = NLP_SENTIMENT_1()
    let tweetCount = 100
        
   let swifter = Swifter(consumerKey: "qC5rSibjSOacnJzyf37yzXLIQ", consumerSecret:        "sUDedN5F4BFEyBs9serNnC9WFDIzqRaqPtb9Uj3ZZXX0nglWi0")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
func fetchTweets() {
    if  let searchText = textField.text {
        swifter.searchTweet(using: searchText, lang: "en",  count: tweetCount, tweetMode: .extended) { results, searchMetadata in
            var tweets = [NLP_SENTIMENT_1Input] ()
            
            for i in 0..<self.tweetCount {
                if let tweet = results[i]["full_text"].string {
                    let tweetForClassification = NLP_SENTIMENT_1Input(text: tweet)
                    tweets.append(tweetForClassification)
                }
            }
            makeprediction(with: tweets)
        } failure: { error in
            print("fail to get tweets: \(error)")
        }
    }
    
func makeprediction(with tweets: [NLP_SENTIMENT_1Input]) {
        do {
            let predictions = try sentimentClassifier.predictions(inputs: tweets) // for batch
            var sentimentScore = 0
            for pred in predictions {
                let sentiment = pred.label
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            print(sentimentScore)
            updateUI(with: sentimentScore)
        }
        catch {
            print("there was an error in making predictions")
            
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
           sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            sentimentLabel.text = "🥰"
        } else if sentimentScore > 0 {
            sentimentLabel.text = "🙂"
        } else if sentimentScore > -10 {
           sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            sentimentLabel.text = "☹️"
        } else if sentimentScore > -30 {
            sentimentLabel.text = "😏"
        } else  {
            sentimentLabel.text = "🤬"
        }
    }
    
 }
}


