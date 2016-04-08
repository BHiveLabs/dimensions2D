# dimensions2D
A 2D library for producing dimensioned drawings from OpenSCAD files.

This library is a first attempt/work in progress at making OpenSCAD more user friendly for when you want to do more than just 3D print your parts. The workflow is:

1. Generate an assembly file. Each part needs to be a separate file.
2. Generate a part file that is called in assembly.scad using the use command.
3. The part files contain the part function which has the same name as the file.
4. Define the part dimensions using constants at the top of the file so that changes in the created object get reflected in the dimensioned parts.
5. It also contains the part sliced up in to top, side and plan elevations as required.
6. These are then dimensioned using the modules from dimensions2D.scad
7. If you need to create a scalable/printable copy, ensure that only 2D objects are produced in the parts file. At present OpenSCAD's svg exporter can not handle 3D objects.
