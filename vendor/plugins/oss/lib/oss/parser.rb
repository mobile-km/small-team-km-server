module Oss
  module Parser
    def parse_error(xml)
      code = Nokogiri::XML(xml).at_css("Error Code").content.strip
      message = Nokogiri::XML(xml).at_css("Error Message").content.strip
      [code,message]
    end
  end
end