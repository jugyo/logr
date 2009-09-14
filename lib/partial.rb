helpers do
  def partial(template, options = {})
    options = options.merge({:layout => false})
    template = "_#{template.to_s}".to_sym
    m = method(:haml)
    m.call(template, options)
  end
end
