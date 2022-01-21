//
//  AuctionItem.swift
//  Auctioneer
//
//  Created by Lester Cheong on 18/1/22.
//

import Foundation

class AuctionItem {
    var productName:String
    var imageUrl:String
    var openedBy:String
    var openDate:Date
    var closeDate:Date
    var startingPrice:Double
    var highestBidPrice:Double
    var highestBidder:String
    var uniqueKey:String
    var isnotClosed:Bool
    
    init(productname:String,imageurl:String, openedby:String, opendate:Date, closedate:Date, startingprice:Double, highestbidprice:Double,
         highestbidder:String, uniquekey:String,isnotclosed:Bool){
        productName = productname
        imageUrl = imageurl
        openedBy = openedby
        openDate = opendate
        closeDate = closedate
        startingPrice = startingprice
        highestBidPrice = highestbidprice
        highestBidder = highestbidder
        uniqueKey = uniquekey
        isnotClosed = isnotclosed
    }
    
}
