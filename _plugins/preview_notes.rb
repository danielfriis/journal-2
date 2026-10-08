# Renders every note a second time under /preview/notes/ with the preview layout,
# so the redesign can be reviewed before it replaces the live pages.
module Jekyll
  class PreviewNotes < Generator
    def generate(site)
      site.posts.docs.each do |post|
        page = PageWithoutAFile.new(site, site.source, "preview#{post.url}", "index.md")
        page.content = post.content
        page.data.merge!(post.data, "layout" => "preview_note", "title_spacing" => "mt-28 mb-20", "noindex" => true, "sitemap" => false)
        site.pages << page
      end
    end
  end
end
