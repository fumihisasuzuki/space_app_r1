module ShopsHelper
  def link_to_web_search(button_name, key_word)
    link_to button_name, current_user.web_search_url + "search?q=" + key_word, class: "btn btn-primary btn-sm", target: :_blank
  end
  
  def link_to_map(button_name, key_word)
    link_to button_name, "https://www.google.co.jp/maps/place/" + "search?q=" + key_word, class: "btn btn-primary btn-sm", target: :_blank
  end
  
end
