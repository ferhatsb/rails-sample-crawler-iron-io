## SearchBox.io Sample Rails Application.

This example illustrates basic search features of SearchBox.io (ElasticSearch as service).

Each CRUD operation on documents is reflected to search index in real time.

To test SearchBox.io's search features navigate to Manage Documents, create a new document and search it.

"Reindex All" at Manage Documents view will index all documents in database in one shot (Paging can be used if required). It will delete old index if exists, create a new index and it will index all documents at database with Bulk API.

Sample application is using [Tire](https://github.com/karmi/tire) Ruby ElasticSearch client to integrate with SearchBox.io.

## Local Setup

Sample app runs with no change at local environment with development profile.

## Heroku Deployment

This sample can be deployed to Heroku with no change. With 2 steps application will be fully functional.

* Migrate database with `heroku run rake db:migrate`

* Install SearchBox ElasticSearch Addon.

Deploy sample application and experience real time search.