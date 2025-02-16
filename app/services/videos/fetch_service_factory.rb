module Videos
  class FetchServiceFactory
    def self.create(url)
      if url.include?("youtube.com") || url.include?("youtu.be")
        Videos::YoutubeFetchService.new(url)
      else
        raise ArgumentError, "Unsupported video platform"
      end
    end
  end
end
