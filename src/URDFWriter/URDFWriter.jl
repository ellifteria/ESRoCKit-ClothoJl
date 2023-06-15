module URDFWriter

# include XML writing tool

include("../deps/juliaxmlwriter/src/XMLWriter.jl")
using .XMLWriter

# include URDF link and joint code

include("./_URDFLink.jl")
include("./_URDFJoint.jl")
using .URDFLink
using .URDFJoint

# URDFWriter exported constants

export urdfwriter_urdf_create,
       urdfwriter_urdf_write

function urdfwriter_urdf_create(name::String="robot")::XmlNode

  return xmlwriter_xmlnode_create("robot", Dict("name" => "\"$(name)\""))

end

function urdfwriter_urdf_write(
    file_path::String,
    urdf_doc::XmlNode
  )

  xmlwriter_xmlnode_write(file_path, urdf_doc)
  
end

end

