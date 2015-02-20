module Elasticsearch
  module DSL
    module Search
      module Aggregations

        # DateHistogram aggregation
        #
        # @example
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-datehistogram-aggregation.html
        #
        class DateHistogram
          include BaseAggregationComponent

          option_method :field
          option_method :interval
          option_method :pre_zone
          option_method :post_zone
          option_method :time_zone
          option_method :pre_zone_adjust_large_interval
          option_method :pre_offset
          option_method :post_offset
          option_method :format
          option_method :min_doc_count
          option_method :extended_bounds
          option_method :order
        end

      end
    end
  end
end
