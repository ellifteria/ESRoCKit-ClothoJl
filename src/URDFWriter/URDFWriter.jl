module URDFWriter

# include XML writing tool

include("../deps/juliaxmlwriter/src/XMLWriter.jl")
using .XMLWriter

# Internal types

Optional{T} = Union{T, Nothing}

# URDFWriter: URDFLink

abstract type AbstractLinkGeometry end

struct Box <: AbstractLinkGeometry
  size_x::Float64
  size_y::Float64
  size_z::Float64
end

# URDFWriter: URDFLink: exported functions

export urdfwriter_urdflink_create

function urdfwriter_urdflink_create_visual(
    name::Optional{String}=nothing,
    origin::Optional{XmlNode}=nothing,
    # !! BELOW IS NOT OPTIONAL!!
    geometry::Optional{XmlNode}=nothing, # !!NEEDS TO NOT BE NOTHING!!
    # !!ABOVE IS NOT OPTIONAL!!
    material::Optional{XmlNode}=nothing
  )

  return

end

function urdfwriter_urdflink_create(
    name::String,
    visual::Optional{XmlNode}=nothing
  )::XmlNode

  link = xmlwriter_xmlnode_create(name)

  if isnothing(visual) == false
    xmlwriter_xmlnode_add_child!(link, visual)
  end

  return link

end

# URDFWriter: URDFJoint: exported functions

export urdfwriter_urdfjoint_create

function urdfwriter_urdfjoint_create(name::String)::XmlNode

  return xmlwriter_xmlnode_create(name)

end


# URDFWriter: URDFFile: exported functions 

export urdfwriter_urdffile_create,
       urdfwriter_urdffile_write,
       urdfwriter_urdffile_add_link!,
       urdfwriter_urdffile_add_joint!

function urdfwriter_urdffile_create(name::String="robot")::XmlNode

  return xmlwriter_xmlnode_create("robot", Dict("name" => "\"$(name)\""))

end

function urdfwriter_urdffile_add_link!(
    urdf_doc::XmlNode,
    link::XmlNode
  )

  xmlwriter_xmlnode_add_child!(urdf_doc, link)

end

function urdfwriter_urdffile_add_joint!(
    urdf_doc::XmlNode,
    joint::XmlNode
  )

  xmlwriter_xmlnode_add_child(urdf_doc, joint)

end

function urdfwriter_urdffile_write(
    file_path::String,
    urdf_doc::XmlNode
  )

  xmlwriter_xmlnode_write(file_path, urdf_doc)

end

end

