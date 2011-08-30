vows   = require 'vows'
assert = require 'assert'
fs     = require 'fs'

feedparser = require '../lib/feedparser'

vows
  .describe('A parser')
  .addBatch

    'New York Times':
      topic: ->
        xml = fs.readFileSync("#{__dirname}/nytimes.xml").toString()
        feedparser.parse xml, @callback

      'can be parsed': (error, feed) ->
        assert.isNull error
        assert.isObject feed

      'provides a feed title': (error, feed) ->
        assert.equal feed.title, "NYT &gt; Home Page"

      'provides a feed link': (error, feed) ->
        assert.equal feed.link, "http://www.nytimes.com/pages/index.html?partner=rss&amp;emc=rss"

      'items':
        topic: (feed) -> feed.items

        'are all included': (items) ->
          assert.isArray items
          assert.length items, 18

        'have titles': (items) ->
          assert.match(item.title, /\w+/) for item in items

        'have links': (items) ->
          assert.match(item.link, /^http:.+nytimes/) for item in items

    'The Conversation AU':
      topic: ->
        xml = fs.readFileSync("#{__dirname}/theconversation.xml").toString()
        feedparser.parse xml, @callback

      'can be parsed': (error, feed) ->
        assert.isNull error
        assert.isObject feed

      'provides a feed title': (error, feed) ->
        assert.equal feed.title, "The Conversation - Science + Technology"

      'provides a feed link': (error, feed) ->
        assert.equal feed.link, "http://theconversation.edu.au"

      'items':
        topic: (feed) -> feed.items

        'are all included': (items) ->
          assert.isArray items
          assert.length items, 25

        'have titles': (items) ->
          assert.match(item.title, /\w+/) for item in items

        'have links': (items) ->
          assert.match(item.link, /^http:.+theconversation/) for item in items

  .export module
