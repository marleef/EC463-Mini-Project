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
    -  This function takes the input of a user ID and queries the username through the ```https://botometer-pro.p.rapidapi.com/``` on the Main Page to determine if the user is a real user or bot.
    -  The user score is presented on the 
  
  - Sentiment Analysis
      - 
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

1. In the project directory enter ```flutter run``` to open and initialize the project. 
    
2. Enter ```2``` for ```[2]: Chrome (chrome)```.


#
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
