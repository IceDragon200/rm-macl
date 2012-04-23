#===============================================================================
# ? SDK
#===============================================================================
# TODO: Clean up and document. Uses some code taken and modified from RGSS1 SDK.
#===============================================================================
module SDK
  VERSION             = 0.1
  #-----------------------------------------------------------------------------
  # * Logging registries
  #-----------------------------------------------------------------------------
  @list               = {}
  @enabled            = {}
  @enabled.default    = false
  @aliases            = {}
  @overwrites         = {}
  @last_script        = 'SDK'
  #-----------------------------------------------------------------------------
  # Logs a custom script
  #-----------------------------------------------------------------------------
  def self.log(script, name, ver, date)
    @list[script]    = [name, ver, date]
    @enabled[script] = @enabled.default
    @last_script     = script
  end
  #--------------------------------------------------------------------------
  # Logs an aliased method
  #--------------------------------------------------------------------------
  def self.log_alias(classname, oldmethodname, newmethodname)
    new_entry = [classname, oldmethodname, newmethodname]
    # Converts values to symbols
    new_entry.collect! { |x| (x.is_a?(Symbol) ? x : x.to_s.to_sym) }
    # Enters into registry
    @aliases[@last_script] = [] unless @aliases.has_key?(@last_script)
    @aliases[@last_script] << value
  end
  #--------------------------------------------------------------------------
  # Logs an overwritten method
  #--------------------------------------------------------------------------
  def self.log_overwrite(classname, methodname)
    new_entry = [classname, methodname]
    # Converts values to symbols
    new_entry.collect! { |x| (x.is_a?(Symbol) ? x : x.to_s.to_sym)}
    # Creates new entry
    @overwrites[@last_script] = [] unless @overwrites.has_key?(@last_script)
    # Don't register if this overwrite has already been logged
    return if @overwrites[@last_script].include?(value)
    # Enters into registry
    @overwrites[@last_script] << value
  end
  #--------------------------------------------------------------------------
  # Enables the passed script
  #--------------------------------------------------------------------------
  def self.enable(script)
    @enabled[script] = true
  end
  #--------------------------------------------------------------------------
  # Disables the passed script
  #--------------------------------------------------------------------------
  def self.disable(script)
    @enabled[script] = false
  end
  #--------------------------------------------------------------------------
  # Enabled test
  #--------------------------------------------------------------------------
  def self.enabled?(script, version = nil)
    # If a version was specified and this script is already registered
    if version != nil && @list.has_key?(script)
      # Return false if given script's version is too low
      return false unless @list[script][1] >= version
    end
    # Returns whether or not the given script is enabled
    return @enabled[script]
  end
  #--------------------------------------------------------------------------
  # * Checks SDK requirements
  #--------------------------------------------------------------------------
  def self.check_requirements(version = VERSION, scripts = [])
    missing_reqs = {}
    # Checks version
    missing_reqs[0] = version unless VERSION >= version
    # Checks required scripts
    if scripts.is_a?(String)
      unless self.enabled?(scripts)
        missing_reqs[2] = [] unless missing_reqs.has_key?(2)
        missing_reqs[2] << scripts
      end
    elsif scripts.is_a?(Array)
      for script in scripts
        unless self.enabled?(script)
          missing_reqs[2] = [] unless missing_reqs.has_key?(2)
          missing_reqs[2] << script
        end
      end
    elsif scripts.is_a?(Hash)
      scripts.each do |script, v|
        if self.enabled?(script) == false
          missing_reqs[2] = [] unless missing_reqs.has_key?(2)
          missing_reqs[2] << script
        elsif self.enabled?(script, v) == false
          missing_reqs[3] = {} unless missing_reqs.has_key?(3)
          missing_reqs[3][script] = v
        end
      end
    end
    if missing_reqs.size > 0
      self.disable(@last_script)
      # TODO: Add error message indicating why this script was disabled
    end
  end
end