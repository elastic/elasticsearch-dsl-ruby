To work on the code, clone the repository and install the dependencies:

```
git clone https://github.com/elasticsearch/elasticsearch-dsl-ruby.git
cd elasticsearch-dsl/
bundle install
```

Use the Rake tasks to run the test suites:

```
bundle exec rake test:unit
bundle exec rake test:integration
```

To launch a separate Elasticsearch server for integration tests, see instructions in the [Elasticsearch Ruby Client](https://github.com/elastic/elasticsearch-ruby/blob/main/CONTRIBUTING.md).
