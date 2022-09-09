xml.rss('version' => '2.0')do
  if @article[:id].nil?
    xml.error('There is no articles')
  else
    xml.article('type' => 'article') do
      xml.title(@article[:title], 'type' => 'article_title')
      xml.tag!('description', @article[:description])
    end
  end
end