xml.rss('version' => '2.0')do
  xml.page_title('List of articles:')

  if @articles.nil? or @articles.empty?
    xml.error('There is no articles')
  else
    @articles.each do |article|
      xml.article('type' => 'article') do
        xml.title(article[:title], 'type' => 'article_title')
        xml.tag!('description', article[:description])
      end
    end
  end
end
