module URDFWriter

# include XML writing tool

include("../deps/juliaxmlwriter/src/XMLWriter.jl")
using .XMLWriter

# URDFWriter: URDFLink exported functions

export urdfwriter_urdflink_create

function urdfwriter_urdflink_create(name::String)::XmlNode

  return xmlwriter_xmlnode_create(name)

end

# URDFWriter: URDFJoint: exported functions

export urdfwriter_urdfjoint_create

function urdfwriter_urdfjoint_create(name::String)::XmlNode

  return xmlwriter_xmlnode_create(name)

end


# URDFWriter exported functions 

export urdfwriter_urdf_create,
       urdfwriter_urdf_write,
       urdfwriter_urdf_add_link!,
       urdfwriter_urdf_add_joint!

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

