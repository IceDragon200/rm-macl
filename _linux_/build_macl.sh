# 
# _linux_/build_macl.sh
#
excpath=./
sambler=$excpath/src/build_tools/script_assembler.rb
echo "Assembler Path: ${sambler}"
#%sambler% build_ins/macl_list_edos.rb builds(ex)/edos_rgss3macl.rb
#%sambler% build_ins/macl_list_edos_std.rb builds(ex)/edos_rgss3macl_std.rb
#%sambler% build_ins/macl_list_edos_dev.rb builds(ex)/edos_rgss3macl_dev.rb

build_norm ()
{
  echo "Building rgss3macl.rb"
  ruby $sambler "${excpath}/build_ins/macl_list.rb" "${excpath}/builds/rgss3macl.rb"
  ruby $sambler "${excpath}/build_ins/macl_list_edos.rb" "${excpath}/builds/edos_rgss3macl.rb"
}

build_std ()
{
  echo "Building rgss3macl_std.rb"
  ruby $sambler "${excpath}/build_ins/macl_list_def_std.rb" "${excpath}/builds/rgss3macl_std.rb"
  ruby $sambler "${excpath}/build_ins/macl_list_edos_std.rb" "${excpath}/builds/edos_rgss3macl_std.rb"
}

build_full ()
{
  echo "Building rgss3macl_dev.rb"
  ruby $sambler "${excpath}/build_ins/macl_list_def_dev.rb" "${excpath}/builds/rgss3macl_dev.rb"
  ruby $sambler "${excpath}/build_ins/macl_list_edos_dev.rb" "${excpath}/builds/edos_rgss3macl_dev.rb"
}

build_norm
build_std
build_full