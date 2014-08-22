require File.join(File.dirname(__FILE__), 'osdd_base')

module OpenSearchDsl
  class OpenSearchDescriptionDocument
    class Image
      include OsddBase

      dsl_methods :height, :width, :type, :url

      def initialize(url, height = nil, width = nil, type = nil)
        fail ArgumentError.new('Missing url') if url.nil_or_whitespace?

        @url, @height, @width, @type = url, height, width, type
      end
    end
  end
end
