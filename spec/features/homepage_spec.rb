feature 'Index page' do
  scenario "show list of saved bookmarks" do
    # connection = PG.connect(dbname: 'bookmark_manager_test')

  # Add the test data
    # connection.exec("INSERT INTO bookmarks VALUES(1, 'http://www.google.co.uk');")
    # connection.exec("INSERT INTO bookmarks VALUES(2, 'http://www.yahoo.co.uk');")
    # connection.exec("INSERT INTO bookmarks VALUES(3, 'http://www.makers.tech');")
    # connection.exec("INSERT INTO bookmarks VALUES(4, 'http://www.lyst.co.uk');")
    Bookmarks.create(url: "http://www.google.co.uk")
    Bookmarks.create(url: "http://www.yahoo.co.uk")
    Bookmarks.create(url: "http://www.makers.tech")
    
  visit '/bookmarks'

    expect(page).to have_content("http://www.google.co.uk")
    expect(page).to have_content("http://www.yahoo.co.uk")
    expect(page).to have_content("http://www.makers.tech")
  end
end
