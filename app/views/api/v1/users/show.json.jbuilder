# frozen_string_literal: true

json.user(@user.username)
json.articles do
  if @user_articles&.empty?
    json.error("haven't")
  else
    json.array! @user_articles do |article|
      json.title(article[:title])
      json.description(article[:description])
    end
  end
end
