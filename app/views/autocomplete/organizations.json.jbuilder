json.results @results do |organization|
  json.id organization.id
  json.text organization.name
end
