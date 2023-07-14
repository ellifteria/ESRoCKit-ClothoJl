module ENNFWriter

include("../../deps/juliaxmlwriter/src/XMLWriter.jl")

using .XMLWriter

# Internal warning messages

const UNCHECKMSG = "SimRoKit.jl does NOT check if"
const LINKMSG = "$(UNCHECKMSG) the provided link is a valid link name"
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
    link::String
)
    @warn "Motor neuron being created for a robot link; $(LINKMSG)"
    
    motor_neuron = xmlwriter_xmlnode_create("motor")

    xmlwriter_xmlnode_addtag!(
        motor_neuron,
        "link",
        "\"$(link)\""
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
    layer::Matrix{Float64}
)
    @warn "Layer being added; $(LAYERMSG)"
    @error "NOT YET IMPLEMENTED"
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
