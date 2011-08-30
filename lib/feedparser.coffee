xmlparser = require 'libxml-to-js'

class Parser
  @NS =
    'http://www.w3.org/2005/Atom': 'atom'

  constructor: (@xml) ->

  parse: (callback) ->
    xmlparser @xml, (error, feed) =>
      return callback error if error?

      @ns = {}
      @ns[Parser.NS[url] or ns] = ns for ns, url of feed['@'].xmlns

      try
        root = feed.channel or feed
        items = root.item or root.entry

        callback null
          title: root.title
          link: if root.link.length then root.link else root.link['@'].href
          items: @parseItem(item) for item in items
      catch error
        callback error

  parseItem: (item) ->
    title: item.title
    link: item["#{@ns.atom}:link"]?['@']?.href or item['pheedo:origLink'] or item['link']?['@']?.href

parse = (xml, callback) ->
  parser = new Parser(xml)
  parser.parse callback

exports.parse = parse
