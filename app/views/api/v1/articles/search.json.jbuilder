# frozen_string_literal: true

json.search do
  if @query.blank?
    json.error("haven't search")
  else
    json.option(@option)
    json.query(@query)
  end
end
json.articles do
  if @articles.blank?
    json.error("haven't articles")
  else
    json.array! @articles do |article|
      json.title(article[:title])
      json.description(article[:description])
    end
  end
end
