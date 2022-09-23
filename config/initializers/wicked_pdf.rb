# frozen_string_literal: true

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
  # Path to the wkhtmltopdf executable: This usually isn't needed if using
  # one of the wkhtmltopdf-binary family of gems.
  # exe_path: '/usr/bin/wkhtmltopdf',
  # :exe_path => Rails.root.join('bin', 'wkhtmltopdf-binary').to_s,
  # -  or
  exe_path: "#{Rails.root}/config/initializers/wkhtmltopdf/bin/wkhtmltopdf.exe",
  # exe_path: 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe',
  # exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf'),

  # :exe_path => "#{ENV['GEM_HOME']}/bin/wkhtmltopdf",
  # exe_path: 'C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe',
  # exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf'),
  # exe_path: "#{File.dirname(__FILE__)}/wkhtmltopdf/bin/wkhtmltopdf.exe",
  #   or
  # exe_path:
  # "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-#{Gem.loaded_specs['wkhtmltopdf-binary'].version}/bin/wkhtmltopdf",
  # :exe_path => "#{ENV['GEM_HOME']}/bin/wkhtmltopdf",
  # Needed for wkhtmltopdf 0.12.6+ to use many wicked_pdf asset helpers
  enable_local_file_access: true,

  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  layout: 'pdf.html'
  # Using wkhtmltopdf without an X server can be achieved by enabling the
  # 'use_xvfb' flag. This will wrap all wkhtmltopdf commands around the
  # 'xvfb-run' command, in order to simulate an X server.
  #
  # use_xvfb: true,
}
