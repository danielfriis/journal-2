module Jekyll
  class Document
    def id
      @id ||= extract_id_from_filename
    end

    private

    def extract_id_from_filename
      id_regex = /\A(\d+)-/
      match = id_regex.match(self.basename)
      match ? match[1] : nil
    end
  end
end