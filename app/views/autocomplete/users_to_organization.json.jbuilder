json.results @results do |user|
  json.id user.id
  json.text user.nickname
end
