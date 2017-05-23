require 'jekyll/tagging'

module Jekyll
  module TaggingFilters2
    def tag_cloud2(site)
      site.tags.map do |tag, posts|
        # tag_link is from Gem jekyll-tagging.
        tag_link("#{tag}(#{posts.size})", tag_url(tag))
      end.join(' ')
    end
  end
end

Liquid::Template.register_filter(Jekyll::TaggingFilters2)
