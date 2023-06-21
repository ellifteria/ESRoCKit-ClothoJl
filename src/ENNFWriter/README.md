# ENNFWriter

Enables the creation of ENNF robot neural network specification files.
An ENNF (Elli's Neural Network Format) file is a SimRoKit specific file type for defining a simulated robot's brain in SimRoKit.

There are two separate ENNF file types: `.ennf1` and `.ennf2` files.
`.ennf2` files are `.npy` NumPy array files that encode the weights and biases&mdash;and thereby the topology as well&mdash;of a robot's  neural network, while
`.ennf1` files are XML-based files that link each input and output neuron to a robot body part; a sensor and join respectively.
Both files are needed in order to encode a robot brain for SimRoKit robot simulations.
The `ENNFWriter` module enables the creation of both file types simultaneously.

## Usage

```julia
include("~/.../ENNFWriter.jl")
using .ENNFWriter
```

### Output

```xml
```
