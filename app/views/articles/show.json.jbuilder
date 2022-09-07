json.article do
  if @articles&.empty?
    json.error("haven't")
  else
    json.title(@article[:title])
    json.description(@article[:description])
  end
end