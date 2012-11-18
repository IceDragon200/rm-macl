def _demo_block
  begin
    yield
    puts '<RUBY> Press return to continue'
    gets 
  rescue Exception => ex
    p ex
    puts ex.backtrace
    gets
  end
end

def rgss_main
  begin
    yield
    # // If Input F12 retry
  end
end