require 'selenium-webdriver'

@you_like_hits_url = 'http://www.youlikehits.com/'
@login_username = 'YOUR USERNAME'
@login_pass = 'YOUR PASSWORD'
@login_button = '.maintable table input'
@stats_url = 'http://www.youlikehits.com/stats.php'
@youtube_url = 'http://www.youlikehits.com/youtubenew2.php'
@view_button = '.followbutton'
@timer = 'span font'
@timer_number = 'font span'
@already_viewed_text_1 = 'You already viewed this video.'
@already_viewed_text_2 = 'You watched '
@skip = '#listall br+ a'
@video_name = '#listall font'
@video_text = ''
@limit_reached_text = 'Views Limit Reached'
@limit_reached_text_body = 'You have reached your hourly views limit. You can only view up to 30 videos every hour. This limit is in place to keep the views from being incorrectly marked and removed as spam.'
@skipped_text = 'You skipped this video.'
@points_text = '#showresult'

# Start of navigation

@session = Selenium::WebDriver.for :firefox
@session.navigate.to @you_like_hits_url

def login_as(username, password)
  login_page_check
  login.send_keys username
  login_pass.send_keys password
  login_button.click
end

def login
  @session.find_element(:css, '#username')
end

def login_pass
  @session.find_element(:css, '#password')
end

def login_button
  @session.find_element(:css, @login_button)
end

def stats_check
  if @session.current_url != @stats_url
    retry_login
  else
    puts 'all shiny captain, on stats.php page!'
  end
end

def retry_login
  @session.quit
  @session = Selenium::WebDriver.for :firefox
  @session.navigate.to @you_like_hits_url
  login_as(@login_username, @login_pass)
end

def login_page_check
  if @session.page_source.include?("YouLikeHits is a promotional tool that will help you grow your Twitter, YouTube, Google+, StumbleUpon, VK, Pinterest, SoundCloud, Websites and more.  It's simple and FREE! Just add your profiles and sites to the YouLikeHits and start growing your online presence!")
    puts "All shiny, captain!"
  else
    retry_login
    puts "On the wrong URL: #{@session.current_url}"
  end
end

def navigate_youtube
  @session.navigate.to @youtube_url
end

# End Navigation

# Start of automation logic

def start_viewing
  if @session.current_url != @youtube_url
    navigate_youtube
  end
end

def click_view_button
  sleep 10
  @session.find_element(:css, @view_button).click
  skip
end

def skip
  sleep 100
  @session.find_element(:css, @skip).click
  sleep 5
  click_view_button
end

# End of automation logic

  def check_limit
    if @session.page_source.include?(@limit_reached_text || @limit_reached_text_body)
      puts "We hit our user's limit!"
      # switch_users add more users to automatically switch to after limit is reached
    end
  end

login_as(@login_username, @login_pass)
stats_check
navigate_youtube
start_viewing
click_view_button
skip
