module URDFWriter

# include XML writing tool

include("../../deps/juliaxmlwriter/src/XMLWriter.jl")
using .XMLWriter

# Internal types

Optional{T} = Union{T, Nothing}

# URDFWriter: URDFOrigin: exported functions

export urdfwriter_urdforigin_create

function urdfwriter_urdfgeom_create(
    xyz::Optional{Vector{Float64}}=nothing,
    rpy::Optional{Vector{Float64}}=nothing
  )::XmlNode

  xml_origin = xmlwriter_xmlnode_create("origin")

  if isnothing(xyz) == false
    xmlwriter_xmlnode_add_tag!(
      xml_origin,
      "rpy",
      "\"$(rpy[1]) $(rpy[2]) $(rpy[3])\""
    )
  end

  if isnothing(rpy) == false
    xmlwriter_xmlnode_add_tag!(
      xml_origin,
      "rpy",
      "\"$(rpy[1]) $(rpy[2]) $(rpy[3])\""
    )
  end

  return xml_origin

end

# URDFWriter: URDFGeom: exported types

export AbstractURDFGeom,
       URDFGeomBox,
       URDFGeomCylinder,
       URDFGeomSphere,
       URDFGeomMesh

abstract type AbstractURDFGeom end

struct URDFGeomBox <: AbstractURDFGeom
  size_x::Float64
  size_y::Float64
  size_z::Float64
end

struct URDFGeomCylinder <: AbstractURDFGeom
  radius::Float64
  length::Float64
end

struct URDFGeomSphere <: AbstractURDFGeom
  radius::Float64
end

struct URDFGeomMesh <: AbstractURDFGeom
  file_path::String
  scale_x::Float64
  scale_y::Float64
  scale_z::Float64
end

# URDFWriter: URDFGeom: exported functions

export urdfwriter_urdfgeom_create

function urdfwriter_urdfgeom_create(
    geometry::AbstractURDFGeom
  )::XmlNode

  xml_geom = xmlwriter_xmlnode_create("geometry")

  geom_type::String = ""

  if isa(geometry, URDFGeomBox)
    geom_type = "box"
  elseif isa(geometry, URDFGeomCylinder)
    geom_type = "cylinder"
  elseif isa(geometry, URDFGeomSphere)
    geom_type = "sphere"
  elseif isa(geometry, URDFGeomMesh)
    geom_type = "mesh"
  end

  xml_geom_spec = xmlwriter_xmlnode_create(geom_type)

  if isa(geometry, URDFGeomBox)
    xmlwriter_xmlnode_add_tag!(
      xml_geom_spec,
      "size",
      "\"$(geometry.size_x) $(geometry.size_y) $(geometry.size_z)\""
    )
  elseif isa(geometry, URDFGeomCylinder)
    xmlwriter_xmlnode_add_tag!(
      xml_geom_spec,
      "radius",
      "\"$(geometry.radius)\""
    )
    xmlwriter_xmlnode_add_tag!(
      xml_geom_spec,
      "length",
      "\"$(geometry.length)"
    )
  elseif isa(geometry, URDFGeomSphere)
    xmlwriter_xmlnode_add_tag!(
      xml_geom_spec,
      "radius",
      "\"$(geometry.radius)\""
    )
  elseif isa(geometry, URDFGeomMesh)
    xmlwriter_xmlnode_add_tag!(
      xml_geom_spec,
      "filename",
      "\"$(geometry.file_path)\""
    )
    xmlwriter_xmlnode_add_tag!(
      xml_geom_spec,
      "scale",
      "\"$(geometry.scale_x) $(geometry.scale_y) $(geometry.scale.z)\""
    )
  end
  xmlwriter_xmlnode_add_child!(xml_geom, xml_geom_spec)

  return xml_geom
  
end

# URDFWriter: URDFVisualMaterial: exported types

# URDFWriter: URDFVisualMaterial: exported functions

# URDFWriter: URDFLink: exported functions

export urdfwriter_urdflink_create,
       urdfwriter_urdflink_create_visual

function urdfwriter_urdflink_create_visual(
    geometry::XmlNode,
    name::Optional{String}=nothing,
    origin::Optional{XmlNode}=nothing,
    material::Optional{XmlNode}=nothing
  )::XmlNode

  xml_visual = xmlwriter_xmlnode_create("visual")

  if isnothing(name) == false
    xmlwriter_xmlnode_add_tag!(xml_visual, "name", name)
  end

  if isnothing(origin) == false
    xmlwriter_xmlnode_add_child!(xml_visual, origin)
  end

  if isnothing(geometry) == false
    xmlwriter_xmlnode_add_child!(xml_visual, geometry)
  end

  if isnothing(material) == false
    xmlwriter_xmlnode_add_child(xml_visual, material)
  end

  return xml_visual

end

function urdfwriter_urdflink_create(
    name::String,
    visual::Optional{XmlNode}=nothing
  )::XmlNode

  link = xmlwriter_xmlnode_create("link", Dict("name" => "\"$(name)\""))

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

