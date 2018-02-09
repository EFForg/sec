# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.config = {
  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  layout: Rails.root.join("app/views/layouts/pdf.html.erb").to_s
}


# Monkey patch WickedPdf until it can run wkhtmltopdf under xvfb
# see https://github.com/mileszs/wicked_pdf/pull/653
require 'shellwords'

class WickedPdf
  def initialize(wkhtmltopdf_binary_path = nil)
    @exe_path = wkhtmltopdf_binary_path || find_wkhtmltopdf_binary_path
    raise "Location of #{EXE_NAME} unknown" if @exe_path.empty?
    system(@exe_path, '--version')
    raise "The executable provided doesn't seem to be #{EXE_NAME}" unless `#{@exe_path} --version`.try(:start_with?, EXE_NAME)
    raise "#{EXE_NAME} isn't running correctly" unless $?.success?

    retrieve_binary_version
  end

  def pdf_from_url(url, options = {})
    # merge in global config options
    options.merge!(WickedPdf.config) { |_key, option, _config| option }
    generated_pdf_file = WickedPdfTempfile.new('wicked_pdf_generated_file.pdf', options[:temp_path])
    command = [*Shellwords.shellsplit(@exe_path)]
    command << '-q' unless on_windows? # suppress errors on stdout
    command += parse_options(options)
    command << url
    command << generated_pdf_file.path.to_s

    print_command(command.inspect) if in_development_mode?

    err = Open3.popen3(*command) do |_stdin, _stdout, stderr|
      stderr.read
    end
    if options[:return_file]
      return_file = options.delete(:return_file)
      return generated_pdf_file
    end
    generated_pdf_file.rewind
    generated_pdf_file.binmode
    pdf = generated_pdf_file.read
    raise "PDF could not be generated!\n Command Error: #{err}" if pdf && pdf.rstrip.empty?
    pdf
  rescue => e
    raise "Failed to execute:\n#{command}\nError: #{e}"
  ensure
    generated_pdf_file.close! if generated_pdf_file && !return_file
  end
end
