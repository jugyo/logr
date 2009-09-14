helpers do
  def entry(id)
    raise ArgumentError, 'id must be numeric' unless id =~ /^\d+$/

    path = File.join('entries', id)
    if File.exists?(path)
      lines = File.read(path).split("\n")
      {:id => id, :title => lines.first, :body => lines[1..-1].join("\n"), :updated_at => File.mtime(path)}
    else
      nil
    end
  end

  def entries(page = 0, par_page = CONFIG["par_page"])
    page = page.to_i
    par_page = par_page.to_i
    start_index = page * par_page
    end_index = start_index + par_page - 1
    Dir['entries/*'].sort.reverse[start_index..end_index].map do |path|
      entry(File.basename(path))
    end
  end
end
