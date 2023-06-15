module URDFWriter

include("../deps/juliaxmlwriter/src/XMLWriter.jl")
using .XMLWriter

# URDFWriter exported constants

export urdfwriter_urdf_create,
       urdfwriter_urdf_write

function urdfwriter_urdf_create(name::String="robot")::XmlNode

  return xmlwriter_xmlnode_create("robot", Dict("name" => "\"$(name)\""))

end

function urdfwriter_urdf_write(
    file_path::String,
    xmlnode::XmlNode
  )

  xmlwriter_xmlnode_write(file_path, xmlnode)
  
end

end
