json.articles do
  if @articles.nil? or @articles.empty?
    json.error("haven't")
  else
    json.array! @articles do |article|
      json.title(article[:title])
      json.description(article[:description])
    end
  end
end