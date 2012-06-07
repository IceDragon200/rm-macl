=begin
  Written by IceDragon
  Conditional Branching Algorithim
  When starting an indent of 0 is assumed:
    indent = 0
  When a branch is detected increase the indent by 1
    indent += 1
  When a branch end is detected decrease the indent by 1
    indent -= 1  
  If the branch evaluates to false, skip every indent greater than the current
    index += 1 if indent > branch_indent  
=end