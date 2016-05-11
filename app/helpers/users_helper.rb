module UsersHelper
  def users_to_login_as_links(users)
    users.map { |user| link_to(user.login, user) }.join(', ').html_safe
  end

  def sponsor_full_name_as_link(user)
    user.sponsor.nil? ? '-' : user_as_link(user.sponsor)
  end

  def make_sponsoring_tree_for_users
    root_user = User.first
    make_sponsoring_tree_for_user(root_user)
  end

  def make_sponsoring_tree_for_user(user)
    content_tag('ul') do
      content = content_tag('li', user_as_link(user))
      user.proteges.each { |protege| content += make_sponsoring_tree_for_user(protege) } if user.proteges.any?
      content
    end
  end

  def reverse_order
    if params[:order].nil? || params[:order] == 'DESC'
      'ASC'
    else
      'DESC'
    end
  end

  def user_as_link(user)
    link_to(user.full_name, user)
  end
end

