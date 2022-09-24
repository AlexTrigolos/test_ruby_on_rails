class Api::V1::NewsController < ApplicationController
  # include HTTParty
  def index
    @path = params[:query_path] #daily_json, latest
    if @path.blank? || (@path != 'daily_json' && @path != 'latest')
      return render json: { error: true, message: "Invalid query_path, can be only 'daily_json' or 'latest'" },
                    status: :bad_request
    end
    @rate = params[:rates_country]
    @response = HTTParty.get("https://www.cbr-xml-daily.ru/#{@path}.js")
    @response_body_json = ActiveSupport::JSON.decode(@response.body)
    if @path == 'daily_json'
      @buf = @response_body_json["Valute"]
    elsif @path == 'latest'
      @buf = @response_body_json["rates"]
    end
    if @rate.nil?
      @body = {}
      @buf.each do |elem|
        @body[elem[0]] = elem[1]
      end
    elsif @rate.blank?
      @body = []
      @buf.each do |elem|
        @body.push(elem[0])
      end
    else
      @body = {}
      @buf.each do |elem|
        if @rate.include? elem[0]
          @body[elem[0]] = elem[1]
        end
      end
    end
  end
end
