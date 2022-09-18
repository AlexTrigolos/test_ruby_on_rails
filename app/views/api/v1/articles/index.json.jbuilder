# frozen_string_literal: true

json.articles do
  if @articles.blank?
    json.error("haven't")
  else
    json.array! @articles do |article|
      json.title(article[:title])
      json.description(article[:description])
    end
  end
end
