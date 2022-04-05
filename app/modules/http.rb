#===============================================================================
#  HTTP module for downloading files
#===============================================================================
require 'net/http'
require 'uri'

module Modules
  #-----------------------------------------------------------------------------
  #  main HTTP component (using SSL by default, can be avoided)
  #-----------------------------------------------------------------------------
  module HTTP
    class << self
      #-------------------------------------------------------------------------
      #  threadded downloading for progress monitoring
      #-------------------------------------------------------------------------
      def download(url, file: nil, use_ssl: true, progress_bar: false)
        #  delete file if already exists
        File.delete(file) if file && File.exist?(file)

        #  start download thread
        download_thread = Thread.new do
          thread = Thread.current
          thread[:body] = []

          uri = URI.parse url
          Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
            http.request_get(uri.path) do |response|
              thread[:length] = response['content-length'].to_i

              File.open(file || '.nul', 'w') do |f|
                response.read_body do |segment|
                  (file ? f : thread[:body]) << segment
                  thread[:completed] = (thread[:completed] || 0) + segment.length
                  thread[:progress] = thread[:completed].quo(thread[:length]) * 100
                  thread[:done] = thread[:progress] >= 100
                end
              end
            end
          end
        end

        # handle progress bar loop if defined
        if progress_bar
          bar_output = Console::ProgressBar.new(download_thread[:length])
          #  loop until thread is done
          bar_output.set(download_thread[:progress].to_f) until download_thread[:done]
          #  finalize progress bar
          bar_output.done
        end

        download_thread
      end
      #-------------------------------------------------------------------------
      #  single await call to output downloaded content
      #-------------------------------------------------------------------------
      def get(url, use_ssl: true)
        thread = download(url, use_ssl: use_ssl)
        '' until thread.join 1
        File.delete('.nul') if File.exist?('.nul')
        thread[:body].first
      end
      #-------------------------------------------------------------------------
    end
  end
  #-----------------------------------------------------------------------------
end
