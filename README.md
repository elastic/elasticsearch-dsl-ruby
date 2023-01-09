# Elasticsearch::DSL

The `elasticsearch-dsl` library provides a Ruby API for the [Elasticsearch Query DSL](http://www.elasticsearch.com/guide/en/elasticsearch/reference/current/query-dsl.html).

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-dsl

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch-dsl', git: 'git://github.com/elasticsearch/elasticsearch-dsl-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-dsl-ruby.git
    cd elasticsearch-dsl-ruby
    bundle install
    rake install

## Usage

The library is designed as a group of standalone Ruby modules, classes and DSL methods,
which provide an idiomatic way to build complex
[search definitions](http://www.elasticsearch.com/guide/en/elasticsearch/reference/current/search-request-body.html).

Let's have a simple example using the declarative variant:

```ruby
require 'elasticsearch/dsl'
include Elasticsearch::DSL

definition = search do
  query do
    match title: 'test'
  end
end

definition.to_hash
# => { query: { match: { title: "test"} } }

require 'elasticsearch'
client = Elasticsearch::Client.new trace: true

client.search body: definition
# curl -X GET 'http://localhost:9200/test/_search?pretty' -d '{
#   "query":{
#     "match":{
#       "title":"test"
#     }
#   }
# }'
# ...
# => {"took"=>10, "hits"=> {"total"=>42, "hits"=> [...] } }
```

Let's build the same definition in a more imperative fashion:

```ruby
require 'elasticsearch/dsl'
include Elasticsearch::DSL

definition = Search::Search.new
definition.query = Search::Queries::Match.new title: 'test'

definition.to_hash
# => { query: { match: { title: "test"} } }
```

The library doesn't depend on an Elasticsearch client -- its sole purpose is to facilitate
building search definitions in Ruby. This makes it possible to use it with any Elasticsearch client:

```ruby
require 'elasticsearch/dsl'
include Elasticsearch::DSL

definition = search { query { match title: 'test' } }

require 'json'
require 'faraday'
client   = Faraday.new(url: 'http://localhost:9200')
response = JSON.parse(
              client.post(
                '/_search',
                JSON.dump(definition.to_hash),
                { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
              ).body
            )
# => {"took"=>10, "hits"=> {"total"=>42, "hits"=> [...] } }
```

## Features Overview

The library allows to programatically build complex search definitions for Elasticsearch in Ruby,
which are translated to Hashes, and ultimately, JSON, the language of Elasticsearch.

All Elasticsearch DSL features are supported, namely:

* [Queries and Filter context](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html)
* [Aggregations](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html)
* [Suggestions](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-suggesters.html)
* [Sorting](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html#request-body-search-sort)
* [Pagination](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html#request-body-search-from-size)
* [Options](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html) (source filtering, highlighting, etc)


**Please see the extensive RDoc examples in the source code and the integration tests.**

## Accessing methods outside DSL blocks' scopes

Methods can be defined and called from within a block. This can be done for values like a `Hash`,
`String`, `Array`, etc. For example:

```ruby
def match_criteria
  { title: 'test' }
end

s = search do
  query do
    match match_criteria
  end
end

s.to_hash
# => { query: { match: { title: 'test' } } }

```

To define subqueries in other methods, `self` must be passed to the method and the subquery must be defined in a block
passed to `instance_eval` called on the object argument. Otherwise, the subquery does not have access to the scope of 
the block from which the method was called. For example:

```ruby
def not_clause(obj)
  obj.instance_eval do
    _not do
      term color: 'red'
    end
  end
end

s = search do
  query do
    filtered do
      filter do
        not_clause(self)
      end
    end
  end
end

s.to_hash
# => { query: { filtered: { filter: { not: { term: { color: 'red' } } } } } }

```


## Development

See [CONTRIBUTING](https://github.com/elastic/elasticsearch-dsl-ruby/blob/main/CONTRIBUTING.md).
