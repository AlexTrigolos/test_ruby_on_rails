# frozen_string_literal: true

json.article do
  if @article[:id].nil?
    json.error("Haven't aticle")
  else
    json.title(@article[:title])
    json.description(@article[:description])
  end
end
