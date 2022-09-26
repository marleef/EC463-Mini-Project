import ast
import nltk
import botometer
import pandas as pd
import tweepy
from flask import Flask, redirect, url_for, render_template, request, session, jsonify, json
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from textblob import TextBlob

app = Flask(__name__)
userId = [{'userId': '34'}]
sentiment = [{"Key": "boston", "Num": 100}]


@app.route('/botometerpost', methods=['PUT'])
def botometerput():
    Id = request.get_data()
    Idjsonify = json.loads(Id.decode('utf-8'))
    Idjsonify = json.loads(Idjsonify)
    userdata = Idjsonify.get('userId')
    userId[0]['userId'] = str(userdata)
    return Idjsonify


@app.route('/botometer', methods=['GET'])
def botometer_page():  # put application's code here
    consumer_key = 'DVpGuGbEsvWptOobV8jofoh5W'
    consumer_secret = '9Xf6rStivVmhnoiX39gUwTzu82kmcNZWutKvtKSKReMNwdvy7f'
    access_token = '1569025925387272193-eeB8czHPQ9SZAG3afgFftQg7FvnUGP'
    access_token_secret = 'GGTtxDeIngmlDrwOReHy8LwuTTiU809AqvQ4D2GSejHr5'
    rapidapi_key = '2322ed408bmsh9b28dc261b30c00p1ce9fcjsnd67f1c0357f2'

    twitter_app_auth = {
        'consumer_key': consumer_key,
        'consumer_secret': consumer_secret,
        'access_token': access_token,
        'access_token_secret': access_token_secret
    }
    botometer_api_url = "https://botometer-pro.p.rapidapi.com"

    bom = botometer.Botometer(
        wait_on_ratelimit=True,
        botometer_api_url=botometer_api_url,
        rapidapi_key=rapidapi_key,
        **twitter_app_auth)
    result = bom.check_account(userId[0]['userId'])
    displaydict = result['display_scores']['english']
    data = displaydict.get("overall")
    return str(data)


@app.route('/sentimentpost', methods=['PUT'])
def sentimentput():
    data = request.get_data()
    datajsonify = data.decode()
    datajsonify = json.loads(datajsonify)
    datajsonify = ast.literal_eval(datajsonify)
    keyW = datajsonify.get('Key')
    nuM = datajsonify.get('Num')
    sentiment[0]['Key'] = str(keyW)
    sentiment[0]['Num'] = str(nuM)
    return jsonify({'sentiment': sentiment[0]})


@app.route('/sentiment', methods=['GET'])
def sentiment_page():  # put application's code here
    # Authentication
    nltk.download('vader_lexicon')
    consumerKey = 'DVpGuGbEsvWptOobV8jofoh5W'
    consumerSecret = '9Xf6rStivVmhnoiX39gUwTzu82kmcNZWutKvtKSKReMNwdvy7f'
    accessToken = '1569025925387272193-eeB8czHPQ9SZAG3afgFftQg7FvnUGP'
    accessTokenSecret = 'GGTtxDeIngmlDrwOReHy8LwuTTiU809AqvQ4D2GSejHr5'
    auth = tweepy.OAuthHandler(consumerKey, consumerSecret)
    auth.set_access_token(accessToken, accessTokenSecret)
    api = tweepy.API(auth, wait_on_rate_limit=True)
    keyword = sentiment[0]['Key']
    noOfTweet = int(sentiment[0]['Num'])
    tweets = tweepy.Cursor(api.search, q=keyword).items(noOfTweet)
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
    return [totalR, posR, negR, neuR]


def percentage(part, whole):
    return 100 * float(part) / float(whole)


if __name__ == '__main__':
    app.run()
