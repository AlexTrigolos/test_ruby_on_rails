# frozen_string_literal: true

xml.rss('version' => '2.0') do
  xml.page_title('List of articles:')
  xml.search do
    if @query.blank?
      xml.error(true)
    else
      xml.option(@option)
      xml.query(@query)
    end
  end
  if @articles.blank?
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
