require 'test_helper'

class UserTest < ActiveSupport::TestCase
  GDURAND = "gdurand"
  MDUPONT = "mdupont"

  test "there is two users" do
    assert User.all.size == 2
  end

  test "the last user's login is #{MDUPONT}" do
    assert_equal MDUPONT, User.last.login
  end

  test "there is a user whose login is #{GDURAND}" do
    user = User.find_by(login: GDURAND)
    refute_nil user
    assert_equal GDURAND, user.login
  end

  test "#{MDUPONT} has no sponsor" do
    user = User.find_by(login: MDUPONT)
    refute_nil user

    sponsor = user.sponsor
    assert_nil sponsor
  end

  test "#{GDURAND} is sponsored by #{MDUPONT}" do
    user = User.find_by(login: GDURAND)
    refute_nil user

    sponsor = user.sponsor
    refute_nil sponsor
    assert_equal MDUPONT, sponsor.login
  end
end
