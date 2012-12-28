class MusicSearch
  attr_reader :music_title, :album_title, :author_name

  def initialize(key)
    @key = key
  end


  def search
    # 发出请求，从API URL获取 JSON 数据
    begin
      fetch
    rescue Exception
      return local_search
    end

    return local_search if @music_items.blank?

    # 保存到数据库, 并返回数组
    store
  end

  def local_search
    MusicInfo.find_items(@key)
  end


  def fetch
    page = 1
    num = 20

    key = CGI.escape(@key)
    url = "http://kuang.xiami.com/app/nineteen/search/key/#{key}/logo/1/num/#{num}/page/#{page}?callback"
    uri = URI.parse(url)

    target = Net::HTTP.new(uri.host, uri.port)
    music_json = target.get2(uri.path, {'accept'=>'text/json'}).body
    @music_result = JSON.parse(music_json)

    @music_items = @music_result['results']
  end


  def store
    

    music_arr = @music_items.map do |item|
      music = {}

      music[:album_title] = CGI.unescape(item['album_name'])
      music[:author_name] = CGI.unescape(item['artist_name'])
      music[:music_title] = CGI.unescape(item['song_name'])
      music[:cover_src] = CGI.unescape(item['album_logo'])

      current = MusicInfo.get_by_info(music)

      if current.blank?
        MusicInfo.create(music)
      else
        current.update_attributes(music)
      end
    end

    music_arr
  end

end
