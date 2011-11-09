
![](Screenshot.png)

# CloudDrop

CloudDrop is a super simple web application, which allows you to upload a file, and share a obscured URL for people to download it (ie clouddrop.org/820v$F194).

The app does not require user tracking. There is *no* way retrieve previous uploads. Instead, each time you upload you get a unique URL, which will expire in x days. the expiration is updated each time a download is triggered.

# Goals

* zero config
* security by obscurity
* time-out

# Considerations

## What framework to use.

Considering the super simple functionality, framework should be 

* ultra simple
* works with passenger

Current preference is for Sinatra.

## Database setup

Database setup

* original file name
* url to get it from
* time of last access
