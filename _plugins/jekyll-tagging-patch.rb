require 'jekyll/tagging'

module Jekyll
  module TaggingFilters2
    def tag_cloud2(site)
      tags_with_count(site).map do |tag, count|
        # tag_link is from Gem jekyll-tagging.
        tag_link("#{tag}(#{count})", tag_url(tag))
      end.join(' ')
    end

    def tags_with_count(site)
      @tags_with_count ||= site.tags.sort_by {|e| e[0]}.map {|tag, posts| [tag, posts.size] }
    end
  end
end

Liquid::Template.register_filter(Jekyll::TaggingFilters2)
