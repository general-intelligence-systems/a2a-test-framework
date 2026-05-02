#!/usr/bin/env ruby
# frozen_string_literal: true

# split_spec.rb
# Downloads the A2A specification markdown and splits it into separate files
# by heading (##, ###, ####, etc.), outputting to ./specs/

require 'net/http'
require 'uri'
require 'fileutils'

URL = 'https://raw.githubusercontent.com/a2aproject/A2A/main/docs/specification.md'
OUTPUT_DIR = File.join(__dir__, 'specs')

def download(url)
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPRedirection
    download(response['location'])
  when Net::HTTPSuccess
    response.body
  else
    abort "Failed to download: #{response.code} #{response.message}"
  end
end

def slugify(text)
  text
    .downcase
    .gsub(/[^a-z0-9\s-]/, '')  # remove special chars
    .strip
    .gsub(/\s+/, '-')          # spaces to hyphens
    .gsub(/-+/, '-')           # collapse multiple hyphens
end

def split_by_headings(content)
  sections = []
  current_section = nil

  content.each_line do |line|
    if line.match?(/^\#{2,}\s/)
      # Start a new section
      sections << current_section if current_section
      current_section = { heading: line.rstrip, body: line }
    else
      if current_section
        current_section[:body] += line
      else
        # Content before the first heading (preamble)
        sections << { heading: nil, body: (sections.empty? ? '' : sections.last[:body]) + line } if sections.empty?
        if sections.empty?
          sections << { heading: nil, body: line }
        else
          sections.first[:body] += line unless current_section
        end
      end
    end
  end

  sections << current_section if current_section
  sections
end

def generate_filename(index, heading)
  return '00-preamble.md' if heading.nil?

  # Extract heading text (strip leading ##+ and whitespace)
  text = heading.sub(/^#+\s*/, '').strip
  slug = slugify(text)

  # Pad index for sorting
  format('%02d-%s.md', index, slug)
end

def main
  puts "Downloading specification from #{URL}..."
  content = download(URL)
  puts "Downloaded #{content.bytesize} bytes."

  sections = split_by_headings(content)
  puts "Found #{sections.length} sections."

  FileUtils.mkdir_p(OUTPUT_DIR)

  sections.each_with_index do |section, idx|
    filename = generate_filename(idx, section[:heading])
    filepath = File.join(OUTPUT_DIR, filename)
    File.write(filepath, section[:body])
    puts "  #{filename} (#{section[:body].bytesize} bytes)"
  end

  puts "\nDone! #{sections.length} files written to #{OUTPUT_DIR}/"
end

main
