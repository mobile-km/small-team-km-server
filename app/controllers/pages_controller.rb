class PagesController < ApplicationController
  def add
  end

  def collect
    RemotePage.new(URI params[:url]).fetch do |page|
      @note = Note.create :content => page.content,
                          :kind    => Note::Kind::TEXT
    end

    render :json   => {:result => 'success'}
  rescue Errno::ETIMEDOUT
    render :json   => {:result => 'timeout'},
           :status => 408
  rescue SocketError
    render :json   => {:result => 'gone'},
           :status => 410
  rescue RemotePage::ResourceNotFoundError
    render :json   => {:result => 'notfound'},
           :status => 404
  rescue RemotePage::ContentTypeError,
         RemotePage::InvalidURLError
    render :json   => {:result => 'notacceptable'},
           :status => 406
  end
end
