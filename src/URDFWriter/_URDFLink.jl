module URDFLink

# include XML writing tool

using ..XMLWriter

# URDFLink exported functions

export urdflink_create

function urdflink_create(name::String)::XmlNode

  return xmlwriter_xmlnode_create(name)

end

end

