class MusicSearch
  attr_reader :music_title, :album_title, :author_name

  def initialize(key)
    @key = key
  end


  def search
    # 发出请求，从API URL获取 JSON 数据
    fetch

    # 保存到数据库, 并返回数组
    store
  end


  def fetch
    page = 1
    num = 3
    url = "http://kuang.xiami.com/app/nineteen/search/key/#{@key}/logo/1/num/#{num}/page/#{page}?callback"
    uri = URI.parse(url)

    target = Net::HTTP.new(uri.host, uri.port)
    music_json = target.get2(uri.path, {'accept'=>'text/json'}).body
    @music_list = JSON.parse(music_json)
  end


  def store
    items = @music_list['results']

    music_arr = items.map do |item|
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
