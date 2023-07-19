module ENNFWriter

include("../../deps/juliaxmlwriter/src/XMLWriter.jl")

using .XMLWriter

# Internal warning messages

const UNCHECKMSG = "SimRoKit.jl does NOT check if"
const LINKMSG = "$(UNCHECKMSG) the provided link is a valid link name"
const JOINTMSG = "$(UNCHECKMSG) the provided joint is a valid joint name"
const LAYERMSG = "$(UNCHECKMSG) the provided layer is valid with respect to the sizes of the preceeding and following layers"

export ennfwriter_enf_create,
    ennfwriter_ennf_write,
    ennfwriter_layer_add!,
    ennfwriter_neuron_motor_add!,
    ennfwriter_neuron_sensor_add!

function ennfwriter_neuron_sensor_add!(
    ennf_doc::XmlNode,
    index::Int64,
    link::String
)
    @warn "Sensor neuron being created for a robot link; $(LINKMSG)"

    sensor_neuron = xmlwriter_xmlnode_create("sensor")

    xmlwriter_xmlnode_addtag!(
        sensor_neuron,
        "link",
        "\"$(link)\""
    )

    xmlwriter_xmlnode_addtag!(
        sensor_neuron,
        "index",
        "\"$(index)\""
    )

    xmlwriter_xmlnode_addchild!(ennf_doc, sensor_neuron)
end

function ennfwriter_neuron_motor_add!(
    ennf_doc::XmlNode,
    index::Int64,
    joint::String
)
    @warn "Motor neuron being created for a robot joint; $(JOINTMSG)"
    
    motor_neuron = xmlwriter_xmlnode_create("motor")

    xmlwriter_xmlnode_addtag!(
        motor_neuron,
        "joint",
        "\"$(joint)\""
    )

    xmlwriter_xmlnode_addtag!(
        motor_neuron,
        "index",
        "\"$(index)\""
    )

    xmlwriter_xmlnode_addchild!(ennf_doc, motor_neuron)
end

function ennfwriter_layer_add!(
    ennf_doc::XmlNode,
    layer::Union{Matrix{Float64}, Matrix{Int64}},
    index::Int64
)
    @warn "Layer being added; $(LAYERMSG)"

    layer_as_string = string(layer)

    start_index = findfirst("[", layer_as_string)[1] + 1;
    finish_index = findfirst("]", layer_as_string)[1] - 1;

    modified_layer_as_string = layer_as_string[start_index:finish_index]

    layer_node = xmlwriter_xmlnode_create("neuron_layer")

    xmlwriter_xmlnode_addtag!(
        layer_node,
        "index",
        "\"$(index)"
    )

    xmlwriter_xmlnode_addtag!(
        layer_node,
        "layer_matrix",
        "\"$(modified_layer_as_string)\""
    )

    xmlwriter_xmlnode_addchild!(ennf_doc, layer_node)
end

function ennfwriter_enf_create(name::String="robot")::XmlNode
    return xmlwriter_xmlnode_create("robot_brain", Dict("name" => "\"$(name)\""))
end

function ennfwriter_ennf_write(
    file_path::String,
    ennf_doc::XmlNode
)
    xmlwriter_xmlnode_write(file_path, ennf_doc)
end

end
