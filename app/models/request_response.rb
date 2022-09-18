class RequestResponse < ApplicationRecord
  validates :remote_ip, :request_method, :request_url, :response_status, :response_content_type, presence: true
end
