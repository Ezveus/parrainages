require 'test_helper'

class UserTest < ActiveSupport::TestCase
  GDURAND = 'gdurand'
  MDUPONT = 'mdupont'
  HBOUCHET = 'hbouchet'
  BBERNARD = 'bbernard'
  FPERRIN = 'fperrin'
  MBOULANGER = 'mboulanger'
  CDUBOIS = 'cdubois'

  setup do
    @gdurand = users(:gdurand)
    @mdupont = users(:mdupont)
    @hbouchet = users(:hbouchet)
    @bbernard = users(:bbernard)
    @fperrin = users(:fperrin)
    @mboulanger = users(:mboulanger)
    @cdubois = users(:cdubois)
  end

  test "there is a user whose login is #{GDURAND}" do
    user = User.find_by(login: GDURAND)
    refute_nil user
    assert_equal GDURAND, user.login
  end

  test "#{MDUPONT} has no sponsor" do
    sponsor = @mdupont.sponsor
    assert_nil sponsor
  end

  test "#{GDURAND} is sponsored by #{MDUPONT}" do
    sponsor = @gdurand.sponsor
    refute_nil sponsor
    assert_equal MDUPONT, sponsor.login
  end

  test "#{MDUPONT} has 2 proteges" do
    assert_equal 2, @mdupont.proteges.size
  end

  test 'there is 5 people who sponsored noone' do
    assert_equal 5, User.with_no_proteges.size
  end

  test 'there is 3 people who sponsored more than 1 protege' do
    assert_equal 3, User.with_more_than_x_proteges(1).length
  end

  test "the 2 people who sponsored the most of proteges are #{HBOUCHET} and #{GDURAND}" do
    sponsors = User.who_sponsored_most_people(2).map { |sponsor| sponsor.login }
    assert_equal 2, sponsors.size
    assert_includes sponsors, HBOUCHET
    assert_includes sponsors, GDURAND
  end

  test "the initial sponsor of #{MDUPONT} is himself" do
    assert_equal MDUPONT, @mdupont.initial_sponsor.login
  end

  test "the initial sponsor of #{MBOULANGER} is #{MDUPONT}" do
    assert_equal MDUPONT, @mboulanger.initial_sponsor.login
  end

  test "when #{MDUPONT} is deleted, #{GDURAND} and #{BBERNARD} have no sponsor anymore" do
    @mdupont.delete_with_responsoring
    assert_nil @gdurand.sponsor
    assert_nil @bbernard.sponsor
  end

  test "when #{HBOUCHET} is deleted, #{MBOULANGER}, #{CDUBOIS} and #{FPERRIN} have #{GDURAND} as sponsor" do
    @hbouchet.delete_with_responsoring
    @mboulanger = User.find_by(login: MBOULANGER)
    @cdubois = User.find_by(login: CDUBOIS)
    @fperrin = User.find_by(login: FPERRIN)
    assert_equal GDURAND, @mboulanger.sponsor.login
    assert_equal GDURAND, @cdubois.sponsor.login
    assert_equal GDURAND, @fperrin.sponsor.login
  end
end
