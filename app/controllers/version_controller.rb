class VersionController < ApplicationController
  def check_version
    result = VersionChangeLog.check_version(params[:version])
    return :json => result
  rescue Exception => ex
    render :text => ex.message,:status => 500
  end
end