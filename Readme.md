Welcome to Chipp'd
========

## Developing

Pristine is running on Rails 3.2.13 with MongoDB as its backend.

### MongoDB

To get the app running locally on your machine, you first need to have MongoDB installed. The easiest way to do this on a Mac is via [Homebrew](https://github.com/mxcl/homebrew). If you do not have homebrew installed, you can do that by following the instructions [here](https://github.com/mxcl/homebrew/wiki/installation). Once homebrew is installed, installing MongoDB is as simple as:

    brew install mongodb

Make sure you follow the instructions at the end of the install process so MongoDB is started automatically for you when your computer boots up.

#### Importing a production database snapshot locally

```
    bundle exec rake db:sync:local
```

### File Attachments

To sync file attachments between environments, you need to log into [the S3 console](http://aws.amazon.com) and copy the uploads folder between buckets. **Important**: Be careful when you do this so that you don't accidentally delete your production assets.

### Rails Setup

Rails setup is simple. There aren't any migration tasks because we're using MongoDB.

    bundle install
    bundle exec rails s

After that, the app will be running at http://0.0.0.0:3000.

## Deployment

There are both staging and production servers for Chipp'd. Changes to these servers are deployed by pushing code to the staging and master branches of the repository respectively. Prior to actually being deployed, code is run through the continuous integration process, and if all tests pass, the site is deployed to the appropriate server. **Important**: because code on the master and staging branches is automatically deployed, work should **never** be done on these branches directly.

### Staging

You can setup your local repository for the staging environment by doing the following:

``` bash
# Setup staging remote branch
git fetch origin
git branch --track staging origin/staging
```

Then, deploying to `staging` is as simple as:

``` bash
git push origin staging
```

The staging site is available at https://chippd-staging.herokuapp.com.

### Production

Deploying to `production` is as simple as:

``` bash
git push origin master
```

## Misc

### Sitemaps

[Documentation](https://github.com/kjvarga/sitemap_generator)

Using `rake sitemap:refresh` will notify major search engines to let them know that a new sitemap is available (Google, Bing). To generate new sitemaps without notifying search engines (for example when running in a local environment) use `rake sitemap:refresh:no_ping`

[Source](https://github.com/kjvarga/sitemap_generator#pinging-search-engines)
