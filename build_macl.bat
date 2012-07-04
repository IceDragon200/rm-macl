src\build_tools\script_assembler build_ins/macl_list.rb rgss3macl.rb
src\build_tools\script_assembler build_ins/macl_list_def_std.rb builds(ex)/rgss3macl_std.rb
src\build_tools\script_assembler build_ins/macl_list_def_dev.rb builds(ex)/rgss3macl_dev.rb
src\build_tools\script_assembler build_ins/macl_list_edos.rb builds(ex)/edos_rgss3macl.rb
src\build_tools\script_assembler build_ins/macl_list_edos_std.rb builds(ex)/edos_rgss3macl_std.rb
src\build_tools\script_assembler build_ins/macl_list_edos_dev.rb builds(ex)/edos_rgss3macl_dev.rb
del /q lib
del /q edos_lib
src\build_tools\asm_folder src lib
src\build_tools\asm_folder --incur --edos src edos_lib