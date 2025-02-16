module Videos
  class FetchService
    attr_reader :user, :url

    def initialize(url)
      @url = url
    end

    def call
      raise NotImplementedError, "Subclasses must implement this method"
    end

    protected

    def format_output(title:, description:)
      {
        title: title,
        description: description
      }
    end
  end
end
