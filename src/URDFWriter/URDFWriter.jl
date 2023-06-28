module URDFWriter

# include XML writing tool

include("../../deps/juliaxmlwriter/src/XMLWriter.jl")
using .XMLWriter

export XmlNode, XmlPreamble

# Internal types

Optional{T} = Union{T, Nothing}

# Internal warning messages

const UNCHECKMSG = "SimRoKit.jl does NOT check if"
const SAFETYCONTROLLERMSG = "($UNCHECKMSG) the provided safety controller uses valid limits"
const JOINTMIMICMSG = "$(UNCHECKMSG) the provided mimic follows a valid joint"

# URDFWriter: URDF Origin: exported functions

export urdfwriter_urdforigin_create

function urdfwriter_urdforigin_create(
    xyz::Optional{Union{Vector{Int64}, Vector{Float64}}}=nothing,
    rpy::Optional{Union{Vector{Int64}, Vector{Float64}}}=nothing
  )::XmlNode

  xml_origin = xmlwriter_xmlnode_create("origin")

  if !isnothing(xyz)
    xmlwriter_xmlnode_add_tag!(
      xml_origin,
      "xyz",
      "\"$(xyz[1]) $(xyz[2]) $(xyz[3])\""
    )
  end

  if !isnothing(rpy)
    xmlwriter_xmlnode_add_tag!(
      xml_origin,
      "rpy",
      "\"$(rpy[1]) $(rpy[2]) $(rpy[3])\""
    )
  end

  return xml_origin

end

# URDFWriter: URDF Geom: exported types

export AbstractURDFGeom,
       URDFGeomBox,
       URDFGeomCylinder,
       URDFGeomSphere,
       URDFGeomMesh

abstract type AbstractURDFGeom end

struct URDFGeomBox <: AbstractURDFGeom
  size_x::Union{Int64, Float64}
  size_y::Union{Int64, Float64}
  size_z::Union{Int64, Float64}
end

struct URDFGeomCylinder <: AbstractURDFGeom
  radius::Union{Int64, Float64}
  length::Union{Int64, Float64}
end

struct URDFGeomSphere <: AbstractURDFGeom
  radius::Union{Int64, Float64}
end

struct URDFGeomMesh <: AbstractURDFGeom
  file_path::String
  scale_x::Union{Int64, Float64}
  scale_y::Union{Int64, Float64}
  scale_z::Union{Int64, Float64}
end

# URDFWriter: URDF Geom: exported functions

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

# URDFWriter: URDF Visual Material: exported functions

export urdfwriter_urdfmaterial_create

function urdfwriter_urdfmaterial_create(
    color::Optional{Union{Vector{Int64}, Vector{Float64}}}=nothing,
    name::Optional{String}=nothing,
    texture_file_path::Optional{String}=nothing
  )::XmlNode

  xml_material = xmlwriter_xmlnode_create("material")

  if !isnothing(name)
    xmlwriter_xmlnode_add_tag!(
      xml_material,
      "name",
      "\"$(name)\""
    )
  end

  if !isnothing(color)
    xmlwriter_xmlnode_add_child!(
      xml_material,
      "color",
      Dict("rgba" => "\"$(color[1]) $(color[2]) $(color[3])\"")
    )
  end

  if !isnothing(texture_file_path)
    xmlwriter_xmlnode_add_tag!(
      xml_material,
      "texture",
      "\"$(texture_file_path)\""
    )
  end

  return xml_material

end

# URDFWriter: URDF Inertial: exported functions

export urdfwriter_urdfinterial_create

function urdfwriter_urdfinterial_create(
  mass::Optional{Union{Int64, Float64}}=nothing,
  inertia::Optional{Union{Vector{Int64}, Vector{Float64}}}=nothing,
  origin::Optional{XmlNode}=nothing
)
  xml_inertial = xmlwriter_xmlnode_create("inertial")

  if !isnothing(mass)
    xmlwriter_xmlnode_add_child!(
      xml_inertial,
      "mass",
      Dict("value" => "\"$(mass)\"")
    )
  end

  if !isnothing(inertia)
    xmlwriter_xmlnode_add_child!(
      xml_inertial,
      "inertia",
      Dict(
        "ixx" => "\"$(inertia[1])\"",
        "ixy" => "\"$(inertia[2])\"",
        "ixz" => "\"$(inertia[3])\"",
        "iyy" => "\"$(inertia[4])\"",
        "iyz" => "\"$(inertia[5])\"",
        "izz" => "\"$(inertia[6])\"",
      )
    )
  end

  if !isnothing(origin)
    xmlwriter_xmlnode_add_child!(xml_inertial, origin)
  end

  return xml_inertial
end

# URDFWriter: URDF Collision: exported functions

export urdfwriter_urdflink_create_collision

function urdfwriter_urdflink_create_collision(
    geometry::XmlNode,
    name::Optional{String}=nothing,
    origin::Optional{XmlNode}=nothing,
  )::XmlNode

  xml_collision = xmlwriter_xmlnode_create("collision")

  if !isnothing(name)
    xmlwriter_xmlnode_add_tag!(xml_collision, "name", "\"$(name)\"")
  end

  if !isnothing(origin)
    xmlwriter_xmlnode_add_child!(xml_collision, origin)
  end

  if !isnothing(geometry)
    xmlwriter_xmlnode_add_child!(xml_collision, geometry)
  end

  return xml_collision

end
# URDFWriter: URDF Visual: exported functions

export urdfwriter_urdflink_create_visual

function urdfwriter_urdflink_create_visual(
    geometry::XmlNode,
    name::Optional{String}=nothing,
    origin::Optional{XmlNode}=nothing,
    material::Optional{XmlNode}=nothing
  )::XmlNode

  xml_visual = xmlwriter_xmlnode_create("visual")

  if !isnothing(name)
    xmlwriter_xmlnode_add_tag!(xml_visual, "name", "\"$(name)\"")
  end

  if !isnothing(origin)
    xmlwriter_xmlnode_add_child!(xml_visual, origin)
  end

  if !isnothing(geometry)
    xmlwriter_xmlnode_add_child!(xml_visual, geometry)
  end

  if !isnothing(material)
    xmlwriter_xmlnode_add_child!(xml_visual, material)
  end

  return xml_visual

end

# URDFWriter: URDF Link: exported functions

export urdfwriter_urdflink_create

function urdfwriter_urdflink_create(
    name::String,
    inertial::Optional{XmlNode}=nothing,
    visual::Optional{XmlNode}=nothing,
    collision::Optional{XmlNode}=nothing,
  )::XmlNode

  link = xmlwriter_xmlnode_create("link", Dict("name" => "\"$(name)\""))

  if !isnothing(inertial)
    xmlwriter_xmlnode_add_child!(link, inertial)
  end

  if !isnothing(visual)
    xmlwriter_xmlnode_add_child!(link, visual)
  end

  if !isnothing(collision)
    xmlwriter_xmlnode_add_child!(link, collision)
  end

  return link

end

# URDFWriter: URDF Axis: exported functions

export urdfwriter_urdfaxis_create

function urdfwriter_urdfaxis_create(
    xyz::Optional{Union{Vector{Int64}, Vector{Float64}}}=nothing,
  )::XmlNode

  xml_axis= xmlwriter_xmlnode_create("axis")

  if !isnothing(xyz)
    xmlwriter_xmlnode_add_tag!(
      xml_axis,
      "xyz",
      "\"$(xyz[1]) $(xyz[2]) $(xyz[3])\""
    )
  end

  return xml_axis

end

# URDFWriter: URDF Callibration: exported functions

export urdfwriter_urdfcallibration_create

function urdfwriter_urdfcallibration_create(
    rising::Optional{Union{Int64, Float64}}=nothing,
    falling::Optional{Union{Int64, Float64}}=nothing
  )::XmlNode

  xml_callibration = xmlwriter_xmlnode_create("callibration")

  if !isnothing(rising)
    xmlwriter_xmlnode_add_tag!(
      xml_callibration,
      "rising",
      "\"$(rising)\""
    )
  end

  if !isnothing(falling)
    xmlwriter_xmlnode_add_tag!(
      xml_callibration,
      "falling",
      "\"$(falling)\""
    )
  end

  return xml_callibration 

end

# URDFWriter: URDF Dynamics: exported functions

export urdfwriter_urdfdynamics_create

function urdfwriter_urdfdynamics_create(
    damping::Optional{Union{Int64, Float64}}=nothing,
    friction::Optional{Union{Int64, Float64}}=nothing
  )::XmlNode

  xml_dynamics = xmlwriter_xmlnode_create("dynamics")

  if !isnothing(damping)
    xmlwriter_xmlnode_add_tag!(
      xml_dynamics,
      "dynamics",
      "\"$(damping)\""
    )
  end

  if !isnothing(friction)
    xmlwriter_xmlnode_add_tag!(
      xml_dynamics,
      "friction",
      "\"$(friction)\""
    )
  end

  return xml_dynamics

end

# URDFWriter: URDF Limit: exported functions

export urdfwriter_urdflimit_create

function urdfwriter_urdflimit_create(
    velocity::Union{Int64, Float64},
    effort::Union{Int64, Float64},
    lower::Optional{Union{Int64, Float64}}=nothing,
    upper::Optional{Union{Int64, Float64}}=nothing  
  )::XmlNode

  xml_limit = xmlwriter_xmlnode_create("limit")

  xmlwriter_xmlnode_add_tag!(
    xml_limit,
    "velocity",
    "\"$(velocity)\""
  )
  
  xmlwriter_xmlnode_add_tag!(
    xml_limit,
    "effort",
    "\"$(effort)\""
  )

  if !isnothing(lower)
    xmlwriter_xmlnode_add_tag!(
      xml_limit,
      "lower",
      "\"$(lower)\""
    )
  end

  if !isnothing(upper)
    xmlwriter_xmlnode_add_tag!(
      xml_limit,
      "upper",
      "\"$(upper)\""
    )
  end

  return xml_limit

end

# URDFWriter: URDF Mimic: exported functions

export urdfwriter_urdfmimic_create

function urdfwriter_urdfmimic_create(
    joint::String,
    multiplier::Optional{Union{Int64, Float64}}=nothing,
    offset::Optional{Union{Int64, Float64}}=nothing,
  )::XmlNode

  @warn "Creating joint mimic; $(JOINTMIMICMSG)"

  xml_mimic = xmlwriter_xmlnode_create("mimic")
    
  xmlwriter_xmlnode_add_tag!(
    xml_mimic,
    "joint",
    "\"$(joint)\""
  )

  if !isnothing(multiplier)
    xmlwriter_xmlnode_add_tag!(
      xml_mimic,
      "multiplier",
      "\"$(multiplier)\""
    )
  end

  if !isnothing(offset)
    xmlwriter_xmlnode_add_tag!(
      xml_mimic,
      "offset",
      "\"$(offset)\""
    )
  end

  return xml_mimic

end

# URDFWriter: URDF Safety Controller: exported functions

export urdfwriter_urdfsafetycontroller_create

function urdfwriter_urdfsafetycontroller_create(
    k_velocity::Union{Int64, Float64},
    k_position::Optional{Union{Int64, Float64}}=nothing,
    soft_lower_limit::Optional{Union{Int64, Float64}}=nothing,
    soft_upper_limit::Optional{Union{Int64, Float64}}=nothing,
  )::XmlNode

  @warn "Creating safety controller; $(SAFETYCONTROLLERMSG)"

  xml_safety_controller = xmlwriter_xmlnode_create("safety_controller")

  xmlwriter_xmlnode_add_tag!(
    xml_safety_controller,
    "k_velocity",
    "\"$(k_velocity)\""
  )
  
  if !isnothing(k_position)
    xmlwriter_xmlnode_add_tag!(
      xml_safety_controller,
      "k_position",
      "\"$(k_position)\""
    )
  end

  if !isnothing(soft_lower_limit)
    xmlwriter_xmlnode_add_tag!(
      xml_safety_controller,
      "soft_lower_limit",
      "\"$(soft_lower_limit)\""
    )
  end

  if !isnothing(soft_upper_limit)
    xmlwriter_xmlnode_add_tag!(
      xml_safety_controller,
      "soft_upper_limit",
      "\"$(soft_upper_limit)\""
    )
  end

  return xml_safety_controller

end

# URDFWriter: URDFJoint: exported functions

export urdfwriter_urdfjoint_create,
  URDFJointType, revolute, continuous,
  prismatic, fixed, floating, planar

@enum URDFJointType begin
  revolute
  continuous
  prismatic
  fixed
  floating
  planar
end

function urdfwriter_urdfjoint_create(
    name::String,
    type::URDFJointType,
    parent::String,
    child::String,
    limit::Optional{XmlNode}=nothing,
    origin::Optional{XmlNode}=nothing,
    axis::Optional{XmlNode}=nothing,
    callibration::Optional{XmlNode}=nothing,
    dynamics::Optional{XmlNode}=nothing,
    mimic::Optional{XmlNode}=nothing,
    safety_controller::Optional{XmlNode}=nothing
  )::XmlNode

  if (type == revolute || type == prismatic) && isnothing(limit)
    throw(ArgumentError("limit must be provided and not nothing for joint type: $(String(Symbol(type)))"))
  end

  joint_node::XmlNode = xmlwriter_xmlnode_create("joint")

  xmlwriter_xmlnode_add_tag!(joint_node, "name", "\"$(name)\"")
  xmlwriter_xmlnode_add_tag!(joint_node, "type", "\"$(String(Symbol(type)))\"")

  xmlwriter_xmlnode_add_child!(
    joint_node,
    "parent",
    Dict("link" => "\"$(parent)\"")
  )
  xmlwriter_xmlnode_add_child!(
    joint_node,
    "child",
    Dict("link" => "\"$(child)\"")
  )
  
  if !isnothing(origin)
    xmlwriter_xmlnode_add_child!(joint_node, origin)
  end

  if !isnothing(axis)
    xmlwriter_xmlnode_add_child!(joint_node, axis)
  end

  if !isnothing(callibration)
    xmlwriter_xmlnode_add_child!(joint_node, callibration)
  end

  if !isnothing(dynamics)
    xmlwriter_xmlnode_add_child!(joint_node, dynamics)
  end

  if !isnothing(limit)
    xmlwriter_xmlnode_add_child!(joint_node, limit)
  end

  if !isnothing(mimic)
    @warn "Joint $(name) mimics another joint; $(JOINTMIMICMSG)"
    xmlwriter_xmlnode_add_child!(joint_node, mimic)
  end

  if !isnothing(safety_controller)
    @warn "Joint $(name) uses a safety controller; $(SAFETYCONTROLLERMSG)"
    xmlwriter_xmlnode_add_child!(joint_node, safety_controller)
  end
  
  return joint_node

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

  xmlwriter_xmlnode_add_child!(urdf_doc, joint)

end

function urdfwriter_urdffile_write(
    file_path::String,
    urdf_doc::XmlNode
  )

  xmlwriter_xmlnode_write(file_path, urdf_doc)

end

end
