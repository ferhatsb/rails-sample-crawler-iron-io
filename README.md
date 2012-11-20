# Iron.io crawler & SearchBox.io Index Search Sample

## Heroku Deployment

* Install SearchBox ElasticSearch Addon.
* Install IronMQ, IronWorker and IronCache Addon.

To create workers;(This will be done from local machine)

* Get your IronWorker id's by heroku config and replace iron.json values.

Execute from your local machine;

* iron_worker upload workers/page_processor --full-remote-build
* iron_worker upload workers/indexer --full-remote-build
* iron_worker upload workers/web_crawler --full-remote-build

Now deploy application, go to curl tab and enter an url to crawl.

Iron.io workers will crawl html content and index it SearchBox.io.

Search from top right to see results.