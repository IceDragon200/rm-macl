require_relative '_rgss3_prototype.rb'
_demo_block do
  require_relative '../rgss3macl.rb'
puts %Q(
-Sword and shield-
If given a sword, you take a shield.
If given a shield, you take a spear.
In life, there is death.
In death there is silence.
You speak not of what you see.
You see not of which you speak.
Your foolishness will surely come back.
To bite you in your deepest rest.
For in 10 days, and 12 nights.
You skipped your sleep every 11
and skipped your fight every 11
For a random fellow like your self.
There is no better ending than a sword to your shield.
~IceDragon
).character_wrap(128).join "\n<TEXT>"
end