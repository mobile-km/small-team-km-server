class Api::MusicInfosController < ApplicationController
  def search
    result = MusicSearcher.new(params[:query]).search

    music_result = result.map{|music_info| music_info.to_hash}

    render :json => music_result
  end
end
