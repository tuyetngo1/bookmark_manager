describe '.all' do
  it 'return a list of bookmarks' do
    connection = PG.connect(dbname: 'bookmark_manager_test')

    # Add the test data
    connection.exec("INSERT INTO bookmarks (url) VALUES ('http://www.google.co.uk');")
    connection.exec("INSERT INTO bookmarks (url) VALUES ('http://www.yahoo.co.uk');")
    connection.exec("INSERT INTO bookmarks (url) VALUES ('http://www.makers.tech');")
    connection.exec("INSERT INTO bookmarks (url) VALUES ('http://www.lyst.co.uk');")

    bookmarks = Bookmarks.all

    expect(bookmarks).to include "http://www.google.co.uk"
    expect(bookmarks).to include "http://www.yahoo.co.uk"
    expect(bookmarks).to include "http://www.makers.tech"
    expect(bookmarks).to include "http://www.lyst.co.uk"
  end
end

describe '.create' do
  it 'create a new bookmark' do
    Bookmarks.create(url:'http://www.testbookmark.com')
    expect(Bookmarks.all).to include 'http://www.testbookmark.com'
  end
end
