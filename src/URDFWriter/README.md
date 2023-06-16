# URDFWriter

Enables the creation of URDF robot specification files.

## Usage

```julia
urdf_doc = urdfwriter_urdffile_create()

link_1 = urdfwriter_urdflink_create("link_1")

urdfwriter_urdffile_add_link!(urdf_doc, link_1)

urdfwriter_urdffile_write("./test.tst.urdf", urdf_doc)
```

### Output

```xml
<robot name="robot">
  <link_1/>
</robot>
```

