from textblob import TextBlob
import sys
import tweepy
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import nltk
#import pycountry
import re
import string
from wordcloud import WordCloud, STOPWORDS
from PIL import Image
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from langdetect import detect
from nltk.stem import SnowballStemmer
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from sklearn.feature_extraction.text import CountVectorizer

def sentiment(keyword, noOfTweet):  # put application's code here
    # Authentication
    nltk.download('vader_lexicon')
    consumerKey = 'DVpGuGbEsvWptOobV8jofoh5W'
    consumerSecret = '9Xf6rStivVmhnoiX39gUwTzu82kmcNZWutKvtKSKReMNwdvy7f'
    accessToken = '1569025925387272193-eeB8czHPQ9SZAG3afgFftQg7FvnUGP'
    accessTokenSecret = 'GGTtxDeIngmlDrwOReHy8LwuTTiU809AqvQ4D2GSejHr5'
    auth = tweepy.OAuthHandler(consumerKey, consumerSecret)
    auth.set_access_token(accessToken, accessTokenSecret)
    api = tweepy.API(auth, wait_on_rate_limit=True)

    tweets = tweepy.Cursor(api.search_tweets, q=keyword).items(noOfTweet)
    positive = 0
    negative = 0
    neutral = 0
    polarity = 0
    tweet_list = []
    neutral_list = []
    negative_list = []
    positive_list = []
    for tweet in tweets:

        # print(tweet.text)
        tweet_list.append(tweet.text)
        analysis = TextBlob(tweet.text)
        score = SentimentIntensityAnalyzer().polarity_scores(tweet.text)
        neg = score['neg']
        neu = score['neu']
        pos = score['pos']
        comp = score['compound']
        polarity += analysis.sentiment.polarity

        if neg > pos:
            negative_list.append(tweet.text)
            negative += 1
        elif pos > neg:
            positive_list.append(tweet.text)
            positive += 1

        elif pos == neg:
            neutral_list.append(tweet.text)
            neutral += 1

    positive = percentage(positive, noOfTweet)
    negative = percentage(negative, noOfTweet)
    neutral = percentage(neutral, noOfTweet)
    polarity = percentage(polarity, noOfTweet)
    positive = format(positive, '.1f')
    negative = format(negative, '.1f')
    neutral = format(neutral, '.1f')
    tweet_list = pd.DataFrame(tweet_list)
    neutral_list = pd.DataFrame(neutral_list)
    negative_list = pd.DataFrame(negative_list)
    positive_list = pd.DataFrame(positive_list)
    totalR = len(tweet_list)
    posR = len(positive_list)
    negR = len(negative_list)
    neuR = len(neutral_list)
    return totalR, posR, negR, neuR


def percentage(part, whole):
    return 100 * float(part) / float(whole)


keyword = input('Please enter keyword or hashtag to search: ')
noOfTweet = int(input('Please enter how many tweets to analyze: '))
totalR, posR, negR, neuR = sentiment(keyword,noOfTweet)
print("total: "+ str(totalR))
print("positive: " + str(posR))
print("neu: " + str(neuR))
print("neg: " + str(negR))