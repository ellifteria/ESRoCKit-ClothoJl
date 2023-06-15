include("./URDFWriter.jl")
using .URDFWriter

urdf_doc = urdfwriter_urdf_create()

urdfwriter_urdf_write("./test.tst.urdf", urdf_doc)

