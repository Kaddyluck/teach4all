set :output, 'log/whenever.log'

every :day do
  env :PATH, ENV['PATH']
  rake "messages:deleted:cleanup"
end

every :week do
  env :PATH, ENV['PATH']
  rake "messages:trashed:cleanup"
end

