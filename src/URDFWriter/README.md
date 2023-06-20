# URDFWriter

Enables the creation of URDF robot specification files.

## Usage

```julia
include("~/.../URDFWriter.jl")
using .URDFWriter

urdf_doc = urdfwriter_urdffile_create()

visual_1 = urdfwriter_urdflink_create_visual(
  urdfwriter_urdfgeom_create(URDFGeomBox(1.0, 1.0, 1.0)),
  "visual_1",
  urdfwriter_urdforigin_create([0.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
  urdfwriter_urdfmaterial_create([1.0, 0.0, 0.0])
)

inertial_1 = urdfwriter_urdfinterial_create(
  1,
  [100.0, 0.0, 0.0, 100.0, 0.0, 100.0],
  urdfwriter_urdforigin_create([0.0, 0.0, 0.0], [0.0, 0, 0])
)

collision_1 = urdfwriter_urdflink_create_collision(
  urdfwriter_urdfgeom_create(URDFGeomBox(1.0, 1.0, 1.0)),
  "collision_1",
  urdfwriter_urdforigin_create([0.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
)

link_1 = urdfwriter_urdflink_create(
  "link_1",
  inertial_1,
  visual_1,
  collision_1
)

urdfwriter_urdffile_add_link!(urdf_doc, link_1)

urdfwriter_urdffile_write("~/.../output.urdf", urdf_doc)
```

### Output

```xml
<robot name="robot">
  <link name="link_1">
    <inertial>
      <mass value="1"/>
      <inertia iyz="0.0" ixy="0.0" ixx="100.0" ixz="0.0" iyy="100.0" izz="100.0"/>
      <origin rpy="0.0 0.0 0.0" xyz="0.0 0.0 0.0"/>
    </inertial>
    <visual name="visual_1">
      <origin rpy="0.0 0.0 0.0" xyz="0.0 0.0 0.0"/>
      <geometry>
        <box size="1.0 1.0 1.0"/>
      </geometry>
      <material>
        <color rgba="1.0 0.0 0.0"/>
      </material>
    </visual>
    <collision name="collision_1">
      <origin rpy="0.0 0.0 0.0" xyz="0.0 0.0 0.0"/>
      <geometry>
        <box size="1.0 1.0 1.0"/>
      </geometry>
    </collision>
  </link>
</robot>
```
