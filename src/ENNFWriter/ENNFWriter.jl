module ENNFWriter

include("../../deps/juliaxmlwriter/src/XMLWriter.jl")

include("./_ENNF1Writer.jl")
include("./_ENNF2Writer.jl")

using ._ENNF1Writer
using ._ENNF2Writer

export _

end