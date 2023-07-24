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
    ennfwriter_network_layer_add!,
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

function ennfwriter_network_layer_add!(
    ennf_doc::XmlNode,
    weight_matrix::Union{Matrix{Float64}, Matrix{Int64}},
    bias_matrix::Union{Vector{Float64}, Vector{Int64}},
    index::Int64
)
    @warn "Layer being added; $(LAYERMSG)"

    weight_matrix_as_string = string(weight_matrix)

    start_index = findfirst("[", weight_matrix_as_string)[1] + 1;
    finish_index = findfirst("]", weight_matrix_as_string)[1] - 1;

    modified_weight_matrix_as_string = weight_matrix_as_string[start_index:finish_index]

    bias_matrix_as_string = string(bias_matrix)

    start_index = findfirst("[", bias_matrix_as_string)[1] + 1;
    finish_index = findfirst("]", bias_matrix_as_string)[1] - 1;

    modified_bias_matrix_as_string = bias_matrix_as_string[start_index:finish_index]

    network_layer_node = xmlwriter_xmlnode_create("network_layer")

    xmlwriter_xmlnode_addtag!(
        network_layer_node,
        "index",
        "\"$(index)\""
    )

    xmlwriter_xmlnode_addtag!(
        network_layer_node,
        "weight_matrix",
        "\"$(modified_weight_matrix_as_string)\""
    )

    xmlwriter_xmlnode_addtag!(
        network_layer_node,
        "bias_matrix",
        "\"$(modified_bias_matrix_as_string)\""
    )

    xmlwriter_xmlnode_addchild!(ennf_doc, network_layer_node)
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
