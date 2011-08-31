xmlparser = require 'libxml-to-js'

NS =
  'http://www.w3.org/2005/Atom': 'atom'

feedNamespaces = (feed) ->
  namespaces = {}
  namespaces[NS[url] or url] = ns for ns, url of feed['@'].xmlns
  namespaces

feedRoot = (feed, namespaces) ->
  feed.channel or feed

feedProperties = (root, namespaces) ->
  title: root.title
  link: if root.link.length then root.link else root.link['@'].href

feedItems = (root, namespaces) ->
  items = root.item or root.entry
  parseItem item, namespaces for item in items

parseItem = (item, namespaces) ->
  title: item.title
  link: item["#{namespaces.atom}:link"]?['@']?.href or item['pheedo:origLink'] or item['link']?['@']?.href or item['link']

parse = (xml, callback) ->
  xmlparser xml, (error, feed) ->
    return callback(error) if error?

    namespaces = feedNamespaces feed
    root = feedRoot(feed, namespaces)

    parsed = feedProperties(root, namespaces)
    parsed.items = feedItems(root, namespaces)

    callback null, parsed

exports.parse = parse
