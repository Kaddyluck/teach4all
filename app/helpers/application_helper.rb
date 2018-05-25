module ApplicationHelper
  BOOTSTRAP_ALERT_TYPES = %w[primary secondary success danger warning info light dark].freeze
  FLASH_MESSAGE_TYPES = (BOOTSTRAP_ALERT_TYPES + %w[notice alert]).freeze

  def flash_messages
    flash.to_hash.select { |key, _value| FLASH_MESSAGE_TYPES.include?(key) }
  end

  def bootstrap_alert_class(type)
    if BOOTSTRAP_ALERT_TYPES.include?(type)
      "alert alert-#{type}"
    elsif type == 'alert'
      'alert alert-danger'
    else
      'alert alert-info'
    end
  end

  def bootstrap_form_validation_class(object, field)
    errors = object.errors
    return '' if errors.blank?
    if errors[field].present?
      'is-invalid'
    else
      'is-valid'
    end
  end

  def react_component(pack, props = {})
    content = javascript_pack_tag(pack.downcase)
    content << content_tag(:div, nil, { id: 'container', data: props })
    content.html_safe
  end

  def active_class(link_path)
    current_page?(link_path) ? 'active' : ''
  end

  def short_time_string(time)
    if time
      time = time.localtime
      if time.today?
        time.strftime("%k:%M")
      elsif (time + 1.day).today?
        "Yesterday"
      else
        time.strftime("%e.%m.%Y")
      end
    else
      ""
    end
  end

  def full_time_string(time)
    if time
      time = time.localtime
      if time.today?
        "Today, #{time.strftime("%k:%M")}"
      elsif (time + 1.day).today?
        "Yesterday, #{time.strftime("%k:%M")}"
      else
        time.strftime("%e.%m.%Y %k:%M")
      end
    else
      ""
    end
  end

  def sortable(column, title=nil)
    column = column.to_s

    title = title ? title : column.to_s.titleize
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'

    content = link_to title, params.permit!.merge({sort: column, direction: direction}), remote: true
    if column == params[:sort]
      case params[:direction]
      when 'asc'
        content << content_tag(:span, "\u2b06")
      when 'desc'
        content << content_tag(:span, "\u2b07")
      end
    end

    content.html_safe
  end

  def course_author(course)
    if course.organization
      author = "From #{link_to(course.organization.name, profile_organization_path(course.organization))}"
    else
      author = "By #{link_to("@#{course.user.nickname}", user_path(course.user))}"
    end
    author.html_safe
  end
end
