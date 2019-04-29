require "s3_zipper/version"
require 's3_zipper/progress'
require "s3_zipper/client"
require "s3_zipper/zip_file"

class S3Zipper
  attr_accessor :keys, :client, :options, :zipfile

  # @param [String] bucket - bucket that files exist in
  # @param [Hash] options - options for zipper
  # @option options [Boolean] :progress - toggles progress tracking
  # @return [S3Zipper]
  def initialize bucket, options = {}
    @options = options
    @client  = Client.new(bucket, options)
  end

  def zip_files keys, filename: SecureRandom.hex, path: nil
    self.zipfile = ZipFile.new(filename)
    self.keys    = keys
    pb           = Progress.new(enabled: options[:progress], format: "'#{zipfile.path}' %e %p% %c/%C %t", total: keys.count, length: 80, autofinish: false)
    self.keys    = keys.each_with_object({ zipped: [], failed: [] }) do |key, hash|
      pb.update 'title', "Key: #{key}"
      client.download_to_tempfile(key) do |file|
        if file.nil?
          hash[:failed] << key
          next
        end
        zipfile.add(key, file)
        hash[:zipped] << key
      end
      pb.increment
      yield(pb.progress) if block_given?
    end
    pb.finish(title: '')
    client.upload(zipfile.path, "#{path}/#{zipfile.filename}") unless self.keys[:zipped].empty?
    zipfile.cleanup
    results
  end

  private

  def results
    { filename: zipfile.filename }.merge(keys)
  end
end