require 'mini_magick'
require 'fileutils'

module Jekyll
  class OgImageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      puts 'Running OgImageGenerator...'

      site.posts.docs.each do |post|
        file_name = "#{post.data['slug'] || post.id}.png"
        image_path = "/assets/og_images/#{file_name}"
        full_path = "#{site.source}#{image_path}" # Generate images in source folder

        # Check if the image already exists
        if File.exist?(full_path)
          puts "Image already exists for post: #{post.data['title']}"
          next
        end

        puts "Generating image for post: #{post.data['title']}"

        title = post.data['title']

        max_width = 30
        wrapped_title = title.gsub(/(.{1,#{max_width}})(\s+|\Z)/, "\\1\n")

        begin
          image = MiniMagick::Image.open("#{site.source}/template.png") # Open a template image
          image.combine_options do |c|
            c.gravity "NorthWest"
            c.pointsize "32"
            c.draw "text 20,20 '#{wrapped_title}'" # Draw the title on the image
          end

          FileUtils.mkdir_p(File.dirname(full_path)) # Ensure the target directory exists
          image.write(full_path) # Write the image to the output directory

          puts "Image generated successfully for post: #{post.data['title']}"
        rescue => e
          puts "Failed to generate image for post: #{post.data['title']}"
          puts "Error: #{e.message}"
        end
      end
    end
  end
end
