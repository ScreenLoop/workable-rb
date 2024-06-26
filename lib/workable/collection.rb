module Workable
  class Collection
    extend Forwardable
    def_delegators :@data, :size, :each, :[], :map, :first

    attr_reader :data
    attr_reader :next_page

    def initialize(data:, next_page_method:, transform_mapping:, root_key:, paging: nil)
      @data = data

      if paging
        @next_page         = paging['next']
        @next_page_method  = next_page_method
        @transform_mapping = transform_mapping
        @root_key          = root_key
      end
    end

    def next_page_since_id
      return if @next_page.nil?

      @next_page.match(/since_id=([^&]*)/)[1]
    end

    def next_page?
      !! @next_page
    end

    def fetch_next_page
      return unless next_page?

      @next_page_method.call(@next_page, @transform_mapping, @root_key)
    end
  end
end
