module Organizations::UsersHelper
  def user_status_label(user)
    status = user.persisted? ? 'registered' : 'unregistered'
    badge_class = user.persisted? ? 'badge-success' : 'badge-warning'
    content_tag :span, status, class: "badge badge-pill #{badge_class}"
  end
end
