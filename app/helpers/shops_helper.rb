module ShopsHelper
  # WEBでキーワード検索するリンクボタン
  def link_to_web_search(button_name, key_words)
    url = add_key_words_for(current_user.web_search_url + "search?q=", key_words)
    link_to button_name, url, class: "btn btn-sm", target: :_blank
  end
  
  # Googleマップでキーワード検索するリンクボタン
  def link_to_map(button_name, key_words)
    url = add_key_words_for("https://www.google.co.jp/maps/" + "place/search?q=", key_words)
    link_to button_name, url, class: "btn btn-sm", target: :_blank
  end
  
  # 路線検索で出発駅と到着駅を指定して検索するリンクボタン
  def link_to_train_search(button_name, from_station, to_station)
    url = current_user.train_search_url + "search/result?flatlon=&fromgid=&from=" + from_station + "&tlatlon=&togid=&to=" + to_station
    link_to button_name, url, class: "btn btn-sm", target: :_blank
  end
  
  # URLにキーワードを追加
  def add_key_words_for(url, key_words)
    key_words.each_with_index do |key_word, counter|
      url += counter.zero? ? key_word : "+" + key_word
    end
    return url
  end

end
