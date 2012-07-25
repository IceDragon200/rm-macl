set sambler=src\build_tools\script_assembler.rb
set asmfold=src\build_tools\asm_folder.rb
%sambler% build_ins/macl_list.rb rgss3macl.rb
%sambler% build_ins/macl_list_def_std.rb builds(ex)/rgss3macl_std.rb
%sambler% build_ins/macl_list_def_dev.rb builds(ex)/rgss3macl_dev.rb
%sambler% build_ins/macl_list_edos.rb builds(ex)/edos_rgss3macl.rb
%sambler% build_ins/macl_list_edos_std.rb builds(ex)/edos_rgss3macl_std.rb
%sambler% build_ins/macl_list_edos_dev.rb builds(ex)/edos_rgss3macl_dev.rb
del /q lib
del /q edos_lib
%asmfold% src lib
%asmfold% --incur --edos src edos_lib