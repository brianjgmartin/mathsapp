json.array!(@myscores) do |myscore|
  json.extract! myscore, :id, :question, :answer, :level, :result, :score, :profile_id
  json.url myscore_url(myscore, format: :json)
end
