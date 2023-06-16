# URDFWriter

Enables the creation of URDF robot specification files.

## Usage

```julia
urdf_doc = urdfwriter_urdffile_create()

visual_1 = urdfwriter_urdflink_create_visual(
  nothing,
  nothing,
  urdfwriter_urdfgeom_create(URDFGeomBox(1.0, 1.0, 1.0)),
  nothing
)

link_1 = urdfwriter_urdflink_create("link_1", visual_1)

urdfwriter_urdffile_add_link!(urdf_doc, link_1)

urdfwriter_urdffile_write("~/.../output.urdf", urdf_doc)
```

### Output

```xml
<robot name="robot">
  <link name="link_1">
    <visual>
      <geometry>
        <box size="1.0 1.0 1.0"/>
      </geometry>
    </visual>
  </link>
</robot>
```

