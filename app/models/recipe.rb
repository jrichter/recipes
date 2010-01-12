require 'feedzirra'
class Recipe < ActiveRecord::Base
has_many :amounts
has_many :ingredients, :through => :amounts

in_place_editable_columns :recipe, :name
in_place_editable_columns :recipe, :author
in_place_editable_columns :recipe, :directions
in_place_editable_columns :recipe, :picture_url


  def self.flickr_feed(rssfeed="http://api.flickr.com/services/feeds/groups_pool.gne?id=78103915@N00&lang=en-us&format=rss_200")
    feed = Feedzirra::Feed.fetch_and_parse(rssfeed)
    image_url = feed.entries[rand(feed.entries.length)].summary.scan(/(<a.*<\/a>)/).last.to_s.gsub(/height=\"\d\d\d\"/, "height=\"172\"").gsub(/width=\"\d\d\d\"/, "width=\"233\"")
    if image_url.scan(/<img src=/) == []
      self.flickr_feed
    else
      return image_url
    end
  end



end
