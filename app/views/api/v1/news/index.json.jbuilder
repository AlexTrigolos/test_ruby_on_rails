# frozen_string_literal: true

if @response_body_json.blank?
  json.error("yps)")
else
  json.body(@body)
end
