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
       urdfwriter_urdf_write,
       urdfwriter_urdf_add_link!,
       urdflink_create

function urdfwriter_urdf_create(name::String="robot")::XmlNode

  return xmlwriter_xmlnode_create("robot", Dict("name" => "\"$(name)\""))

end

function urdfwriter_urdf_add_link!(
    urdf_doc::XmlNode,
    link::XmlNode
  )

  xmlwriter_xmlnode_add_child!(urdf_doc, link)

end

function urdfwriter_urdf_add_joint!(
    urdf_doc::XmlNode,
    joint::XmlNode
  )

  xmlwriter_xmlnode_add_child(urdf_doc, joint)

end

function urdfwriter_urdf_write(
    file_path::String,
    urdf_doc::XmlNode
  )

  xmlwriter_xmlnode_write(file_path, urdf_doc)

end

end

