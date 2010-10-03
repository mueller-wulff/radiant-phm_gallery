module PhmGalleryTags
  include Radiant::Taggable
  require "mini_exiftool"
  desc "Creates Thumbnails"
  tag "phm_thumbs" do |tag|
    answer = ""
    wrap = tag.attr['wrap'].to_s.split('|')
    Dir.glob("#{RAILS_ROOT}/public#{tag.attr['path']}/*_thumb*").sort_by {|f| File.basename f}.each do |image|
      image_public = image.gsub("#{RAILS_ROOT}/public","")
      answer += "#{wrap[0]}
                <a href='#{tag.attr['single_path']}?pic=#{CGI::escape(image_public)}&back=#{CGI::escape(request.path)}'>
                <img src='#{image_public}' />
                </a>
                #{wrap[1]}"
    end
    %{#{answer}}
  end

  desc "renders single image"
  tag "phm_single_pic" do |tag|
    image_big = CGI::unescape(params[:pic]).gsub("thumb","big")
    answer = ""
    answer += "<a href='#{CGI::unescape(params[:back])}'><img src='#{image_big}'/></a>"
    %{#{answer}}
  end

  desc "renders next link"
  tag "phm_next_link" do |tag|
    image_big = CGI::unescape(params[:pic]).gsub("thumb","big")
    answer = ""
    next_pic = ""
    found = false
    gallery = image_big.split("/")
    gallery.pop
    gallery = gallery.join("/")

    Dir.glob("#{RAILS_ROOT}/public#{gallery}/*_big*").sort_by {|f| File.basename f}.each do |image|
      image_public = image.gsub("#{RAILS_ROOT}/public","")
      next_pic = image_public if found == true
      found = false
      found = true if image_public == image_big
    end
    unless next_pic == ""
      answer += "<a href='#{request.path}?pic=#{CGI::escape(next_pic)}&back=#{CGI::escape(params[:back])}'>#{tag.expand}</a>"
    else
      answer += "<a href='#{CGI::unescape(params[:back])}'>#{tag.expand}</a>"
    end
    %{#{answer}}
  end

  desc "renders prev link"
  tag "phm_prev_link" do |tag|
    image_big = CGI::unescape(params[:pic]).gsub("thumb","big")
    answer = ""
    tmp_prev_pic = ""
    prev_pic = ""
    gallery = image_big.split("/")
    gallery.pop
    gallery = gallery.join("/")

    Dir.glob("#{RAILS_ROOT}/public#{gallery}/*_big*").sort_by {|f| File.basename f}.each do |image|
      image_public = image.gsub("#{RAILS_ROOT}/public","")
      prev_pic = tmp_prev_pic if image_public == image_big
      tmp_prev_pic = image_public
    end
    unless prev_pic == ""
      answer += "<a href='#{request.path}?pic=#{CGI::escape(prev_pic)}&back=#{CGI::escape(params[:back])}'>#{tag.expand}</a>"
    else
      answer += "<a href='#{CGI::unescape(params[:back])}'>#{tag.expand}</a>"
    end
    %{#{answer}}
  end
  
  desc "render subtitle"
  tag "phm_subtitle" do |tag|
    answer = ""
    image_big = CGI::unescape(params[:pic]).gsub("thumb","big")
    if image_big.include?(".jpg")
      photo = MiniExiftool.new "#{RAILS_ROOT}/public#{image_big}"
      answer +=  photo.headline.to_s 
    end
    %{#{answer}}
  end
end

