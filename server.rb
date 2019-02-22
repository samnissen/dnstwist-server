require 'sinatra'
require_relative 'dns_twist.rb'

set :bind, '0.0.0.0'

before do
  @d = DNSTwist.new
  content_type 'application/json'
end

get '/:path' do
  @d.lookup(params[:path], params[:opts], params[:callback])
  status 200
  body ''
end
