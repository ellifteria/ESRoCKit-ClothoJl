# URDFWriter

Enables the creation of URDF robot specification files.

## Usage

```julia
include("~/.../URDFWriter.jl")
using .URDFWriter

urdf_doc = urdfwriter_urdffile_create()

visual_1 = urdfwriter_urdflink_create_visual(
  urdfwriter_urdfgeom_create(URDFGeomBox(1.0, 1.0, 1.0)),
  "visual",
  urdfwriter_urdforigin_create([0.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
  urdfwriter_urdfmaterial_create([1.0, 0.0, 0.0])
)

link_1 = urdfwriter_urdflink_create("link_1", visual_1)

urdfwriter_urdffile_add_link!(urdf_doc, link_1)

urdfwriter_urdffile_write("~/.../output.urdf", urdf_doc)
```

### Output

```xml
<robot name="robot">
  <link name="link_1">
    <visual name="visual">
      <origin rpy="0.0 0.0 0.0" xyz="0.0 0.0 0.0"/>
      <geometry>
        <box size="1.0 1.0 1.0"/>
      </geometry>
      <material color="1.0 0.0 0.0"/>
    </visual>
  </link>
</robot>
```

