module ApplicationHelper

  def set_last_visited
    session[:controller] = params[:controller]
    session[:action] = params[:action]
    session[:id] = params[:id]
    session[:view] = params[:view]
    session[:date] = params[:date]
  end

  def last_visited
    return nil unless session[:action] && session[:controller]
    { :action => session[:action],
      :controller => session[:controller],
      :id => session[:id],
      :view => session[:view],
      :date => session[:date] }
  end

  def destroying_displayed_resource?
    params[:id] == session[:id] && params[:controller] == session[:controller]
  end

  def nav_link(link_text, link_path, args={})
    to_be_highlighted = highlight_if do
      params[:controller] == args[:controller]
    end
    prepare_link(link_text, link_path, to_be_highlighted, highlight_class: 'active')
  end

  def subnav_link(link_text, link_path)
    to_be_highlighted = highlight_if do
      current_page?(link_path)
    end
    prepare_link(link_text, link_path, to_be_highlighted, highlight_class: 'active')
  end

  def subnav_link_default(link_text, link_path, args={})
    to_be_highlighted = highlight_if do
      match_pattern = args[:match]
      request.original_url =~ /#{match_pattern}[\/]?$/ || current_page?(link_path)
    end
    prepare_link(link_text, link_path, to_be_highlighted, highlight_class: 'active')
  end

  def subnav_link_default_with_counter(link_text, link_path, counter, args={})
    to_be_highlighted = highlight_if do
      match_pattern = args[:match]
      request.original_url =~ /#{match_pattern}[\/]?$/ || current_page?(link_path)
    end
    prepare_link(link_text, link_path, to_be_highlighted, highlight_class: 'active') do
      counter_raw_html = "<span class='badge'>#{counter}</span>"
      link_text << counter_raw_html if to_be_highlighted
      link_to raw(link_text), link_path
    end
  end

  def subnav_link_with_counter(link_text, link_path, counter)
    to_be_highlighted = highlight_if do
      current_page?(link_path)
    end
    prepare_link(link_text, link_path, to_be_highlighted, highlight_class: 'active') do
      counter_raw_html = "<span class='badge'>#{counter}</span>"
      link_text << counter_raw_html if to_be_highlighted
      link_to raw(link_text), link_path
    end
  end

  def prepare_link(link_text, link_path, to_be_highlighted, args={}, &block)
    highlight_class = to_be_highlighted ? args[:highlight_class] : ''
    content_tag(:li, :class => highlight_class) do
      if block_given?
        block.call
      else
        link_to link_text, link_path
      end
    end
  end

  # syntactic sugar
  def highlight_if
    yield
  end

end
