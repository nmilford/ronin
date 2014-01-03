require "sinatra"
require 'socket'

configure do
  set :bind, "127.0.0.1"
  set :port, 4001
end

@hostname = Socket.gethostname

get "/v2/keys/ronin/config/common" do
  content_type :json
  '{"action":"get","node":{"key":"/ronin/config/common","value":"{\n  \"log_path\": \"common_config\"\n}","modifiedIndex":2,"createdIndex":2}}'
end

get "/v2/keys/ronin/config/#{@hostname}" do
  content_type :json
  '{"action":"get","node":{"key":"/ronin/config/node","value":"{\n  \"log_path\": \"node_config\"\n}","modifiedIndex":2,"createdIndex":2}}'
end

get "/v2/keys/ronin/run_list/common" do
  content_type :json
  '{"action":"get","node":{"key":"/ronin/run_list/common","value":"{\n \"artifacts\": [\n   \"common_artifact\"\n  ]\n}","modifiedIndex":5,"createdIndex":5}}'
end

get "/v2/keys/ronin/run_list/#{@hostname}" do
  content_type :json
  '{"action":"get","node":{"key":"/ronin/run_list/node","value":"{\n \"artifacts\": [\n   \"node_artifact\"\n  ]\n}","modifiedIndex":5,"createdIndex":5}}'
end
