require 'download/version'
require 'open-uri'

module Download

  class Object

    attr_accessor :url, :path, :options

    def initialize(hash={})
      set_multi(hash)
      raise(ArgumentError, 'url is required') unless url
    end

    def uri_file_name
      @uri_file_name ||= URI.parse(url).path.to_s.split('/').last
    end

    # return a string with a file path where the file will be saved
    def file_path

      self.path= File.join(Dir.pwd, uri_file_name) unless path
      if File.directory?(path)
        self.path= File.join(self.path, uri_file_name)
      end

      self.path

    end

    # start the downloading process
    def start(hash={})

      set_multi(hash)

      File.delete(file_path) if File.exist?(file_path)
      File.open(file_path, 'wb') do |file_obj|
        Kernel.open(*[url,options].compact) do |fin|
          while (buf = fin.read(8192))
            file_obj << buf
          end
        end
      end

      return file_path

    end

    protected

    def set_multi(hash={})
      raise(ArgumentError, 'input must be hash!') unless hash.is_a?(Hash)
      hash.each_pair { |key, value| self.public_send("#{key}=", value) unless value.nil? }
    end

  end

  class << self

    # first argumnet is url, required
    # second argument is path, optional
    # third argument is open-uri options, optional
    def file(*args)
      Download::Object.new(
          url: args.shift,
          path: (args[0].is_a?(String) ? args[0] : nil),
          options: (args.last.is_a?(Hash) ? args.last : nil)
      ).start
    end

  end

end