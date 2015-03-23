json.array!(@scores) do |score|
  json.extract! score, :id, :level, :score, :profile_id
  json.url score_url(score, format: :json)
end
