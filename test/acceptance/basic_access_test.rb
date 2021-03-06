require 'require_relative' if RUBY_VERSION[0,3] == '1.8'
require_relative 'acceptance_helper'

describe "basic access" do
  include AcceptanceHelper

  it "visits the root page" do
    visit '/'
    assert_equal 200, page.status_code
  end

  it "visits feeds" do
    feed = Factory(:feed)
    visit "/feeds/#{feed.id}.atom"
    assert_equal 200, page.status_code
  end

  it "visits my user feed" do
    u = Factory(:user)
    visit "/users/#{u.username}/feed"
    assert_equal 200, page.status_code
  end

  it "visits my profile" do
    u = Factory(:user)
    visit "/users/#{u.username}"
    assert_equal 200, page.status_code
  end

  it "edits my profile" do
    u = Factory(:user)
    a = Factory(:authorization, :user => u)
    log_in(u, a.uid)
    visit "/users/#{u.username}"
    click_link "Edit profile"

    assert_equal 200, page.status_code
  end

  it "404s on junk username" do
    visit "/users/1n2i12399992sjdsa21293jj"
    assert_equal 404, page.status_code
  end

  it "404s on invalid feed type" do
    u = Factory(:user, :username => "dfnkt")
    visit "/users/#{u.username}/feed.json"

    assert_equal 404, page.status_code
  end
end
