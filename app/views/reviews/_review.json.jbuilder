json.extract! review, :id, :title, :body, :stars, :created_at, :updated_at
json.url review_url(review, format: :json)
