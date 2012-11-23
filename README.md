text-extractor
==============

A very simple and I mean very simple HTTP wrapper on top of the Yomu gem. Call /extract?url=URL_HERE and you'll get the raw extracted text from the url or an error.

Deployed on Heroku at: http://text-extractor.herokuapp.com/extract?url=http://news.google.com

To run locally:

    mkdir text-extractor
    git clone https://github.com/NearbyFYI/text-extractor.git text-extractor
    cd text-extractor
    heroku git:remote -a text-extractor
    rvm gemset create text-extractor
    rvm gemset use text-extractor
    bundle install
    export PORT=8080
    foreman start
