module Main

  class << self

    def pre_update
    end

    def post_update
    end

    def update
      pre_update
      update_basic
      post_update
    end

    def update_basic
      Graphics.update
      Input.update
    end

  end

end 