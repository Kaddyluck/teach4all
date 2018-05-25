module DashboardHelper
  def course_status_badge(status)
    color =
      case status
      when 'editing'
        'warning'
      when 'validated'
        'primary'
      when 'published'
        'success'
      end
    content_tag :span, status, class: "badge badge-#{color}"
  end

  def course_rating_badge(rating)
    color =
      case rating.truncate
      when -10...-5
        'danger'
      when -5...0
        'warning'
      when 0...5
        'secondary'
      when 5..10
        'success'
      end
    content_tag :span, rating.truncate, class: "badge badge-#{color}"
  end

  def course_result_badge(result)
    color =
    case result.truncate
    when 0...90
      'danger'
    when 90..100
      'success'
    end
    content_tag :span, "#{result.truncate}%", class: "badge badge-#{color}"
  end

  def course_visibility_badge(visibility)
    color =
    case visibility
      when 'for_all_users'
        'success'
      when 'for_organization_users'
        'primary'
      when 'for_selected_users'
        'dark'
      end
      content_tag :span, visibility.humanize(capitalize: false), class: "badge badge-#{color}"
  end

  def dashboard_navbar_show_class
    if url_for.match?('/dashboard/courses/')
      'show'
    else
      ''
    end
  end
end
