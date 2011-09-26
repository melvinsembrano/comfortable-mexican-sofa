class ComfortableMexicanSofa::Tag::Collection
  include ComfortableMexicanSofa::Tag
  
  # Here's a full tag signature:
  #   {{ cms:collection:label:collection_class:collection_partial:collection_title:collection_identifier:collection_params }}
  # A working example of the above:
  #   {{ cms:collection:album:foo/my_album:albums/show:title:slug:param_a:param_b }}
  def self.regex_tag_signature(label = nil)
    label ||= /[\w\/\-]+/
    /\{\{\s*cms:collection:(#{label}):(.*?)\s*\}\}/
  end
  
  # Class definitition. It's basically `Herp::DerpityDerp.undescore` so an example
  # of valid definition is: `herp/derpity_derp`
  def collection_class
    self.params[0].classify
  end
  
  # Path to the partial. Example: `path/to/partial`
  def collection_partial
    self.params[1] || self.collection_class.underscore.pluralize
  end
  
  # Title method for the Collection objects. Default is `label`
  def collection_title
    self.params[2] || 'label'
  end
  
  # Identifier that will be used to find selected collection object. Defaults to `id`
  def collection_identifier
    self.params[3] || 'id'
  end
  
  # Extra params that will be passed to the partial AND ALSO will be passed as parameters
  # for the `cms_collection` scope you can define for your Collection object
  def collection_params
    self.params[4..-1] || []
  end
  
  def content=(value)
    block.content = value
  end
  
  def content
    block.content
  end
  
  def render
    if self.content.present?
      ps = collection_params.collect_with_index{|p, i| ":param_#{i+1} => '#{p}'"}.join(', ')
      ps = ps.present?? ", #{ps}" : ''
      "<%= render :partial => '#{collection_partial}', :locals => {:model => '#{collection_class}', :identifier => '#{content}'#{ps}} %>"
    else
      ''
    end
  end
  
end