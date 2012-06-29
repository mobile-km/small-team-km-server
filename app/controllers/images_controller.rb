class ImagesController < ApplicationController
  def add
  end

  def collect
    RemoteImage.new(URI params[:url]).fetch do |image|
      @note = Note.create :attachment => image.file,
                          :kind       => Note::Kind::IMAGE
    end

    render :json   => {:result => 'success'}
  rescue Errno::ETIMEDOUT
    render :json   => {:result => 'timeout'},
           :status => 408
  rescue SocketError
    render :json   => {:result => 'gone'},
           :status => 410
  rescue RemoteImage::ResourceNotFoundError
    render :json   => {:result => 'notfound'},
           :status => 404
  rescue RemoteImage::ContentTypeError,
         RemoteImage::InvalidURLError
    render :json   => {:result => 'notacceptable'},
           :status => 406
  end
end
