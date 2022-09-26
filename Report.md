# Twitter Monitor App
### Bowen Ma & Marlee Feltham

#
This repository contains the Flutter web application for gathering and monitoring Twitter user account information.

## Overview

  - Query User by ID
      - This function takes the input of a user ID and queries the username through the ```Twitter API v2``` on the Main Page.
      - Pressing the button launches the Query User ID Page to receive user input, and display user ID, name, and username. 
      - Error handling for invalid or empty inputs is included.

  - Check User/Bot Function
    -  This function takes the input of a user ID on the Main Page and queries the username through the ```https://botometer-pro.p.rapidapi.com/``` on the redirected Bos Account Checker Page to determine if the account is a real user or bot.
    -  The user score is presented on the Bot Account Checker Page. The score range is from 0 to 5. In the case of real users, the score will be between 0 to 2. And if the account is more likely to be a robot, the score will have a range between 3 to 5. The gap in between indicates that the Botometer is uncertain about whether given account is a user or a bot.
    -  Error handling for invalid or empty inputs is included.
  
  - Sentiment Analysis
      - This function does not take input from the Main Page. After being directed to the Sentiment Analysis Page with button clicking on the Main Page, the function takes two inputs of a string of keyword and a integer which is the number of tweets the user wants to query to determine the number of tweets that each sentiment has.
      - Each tweets are classified as one of the three sentiments: positive, negative, and neutral based on the algorithms provided by ```nltk.sentiment.vader``` which is one dependency in python library.
      - Error handling for invalid or empty inputs is included.
  - Open Twitter URL
      - Launches ```https://twitter.com/i/flow/login``` webpage.
  - Twitter Timeline
      - Displays user's timeline. Currently cannot be modified by user input and is set to display @NASA.


## Requirements
1. Install dependencies

    i. Flutter ```v3.3.2```

    ii. Dart
    
    iii. Flask

    iv. Python ```v3.7``` or later
    

## Getting Started

1. Download the folder named ```sentimentAPI``` and run ```app.py``` file.

2. In the project directory enter ```flutter run``` to open and initialize the project. 
    
3. Enter ```2``` for ```[2]: Chrome (chrome)```.


#
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
