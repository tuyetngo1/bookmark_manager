require 'sinatra/base'
require './lib/bookmarks'
class BookmarkApp < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/bookmarks' do
    # Print the ENV variable
    p ENV

    @bookmarks = Bookmarks.all
    erb :bookmarks
  end

  get '/bookmarks/new' do
    erb :new
  end

  post '/bookmarks' do
    Bookmarks.create(url: params['url'])
    # connection = PG.connect(dbname: 'bookmark_manager_test')
    # connection.exec("INSERT INTO bookmarks(url) VALUES('#{url}')")
    redirect '/bookmarks'
  end

  run! if app_file == $0
end
