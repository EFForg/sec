module Zipping
  def send_archive(files, number: true)
    digits = [2, Math.log10(files.size).ceil].max

    manifest = files.each_with_index.map do |file, i|
      path = URI::escape(file.path[Rails.root.join("public").to_s.size..-1])

      filename = File.basename(path)
      filename = sprintf("%0#{digits}d-%s", i+1, filename) if number

      "- #{file.size} #{path} #{filename}"
    end.join("\r\n")

    response.headers["X-Archive-Files"] = "zip"
    send_data manifest, type: :text, disposition: "inline"
  end
end
