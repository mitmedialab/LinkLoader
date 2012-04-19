class Link < ActiveRecord::Base
  belongs_to :search
  def add_source(handle)
    list_of_sources = []
    list_of_sources = self.sources.split(",") unless self.sources == nil
    list_of_sources << "@"+handle
    self.sources = list_of_sources.join(",")
  end
end

