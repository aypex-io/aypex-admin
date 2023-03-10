module Aypex
  module Admin
    module DigitalHelper
      def asset_icon(asset)
        file_name = case asset.attachment.content_type
        when /pdf\z/
          "file-earmark-pdf.svg"
        when /\Aimage/
          "file-earmark-image.svg"
        when /zip\z/
          "file-earmark-zip.svg"
        when "text/csv", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          "file-earmark-spreadsheet.svg"
        when /\Avideo/
          "file-earmark-play.svg"
        when /\Aaudio/
          "file-earmark-music.svg"
        when /\Afont/
          "file-earmark-font.svg"
        else
          "file-earmark.svg"
        end

        aypex_admin_svg_tag file_name, size: "50px * 50px"
      end
    end
  end
end
