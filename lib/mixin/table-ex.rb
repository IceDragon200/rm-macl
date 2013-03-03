#
# RGSS3-MACL/lib/mixin/table-ex.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 03/03/2013
# vr 2.1.0
module MACL
  module Mixin
    module TableEx

      ##
      # nudge!(int nx, int ny, int nz)
      #   Moves data in the table relatively
      def nudge!(nx, ny, nz)
        src_table = self.dup
        xs, ys, zs = tabclone.xsize, tabclone.ysize, tabclone.zsize
        if zs > 1
          for z in 0...zs
            for y in 0...ys
              for x in 0...xs
                n = src_table[x, y, z]
                self[(x + nx) % xs, (y + ny) % ys, (z + nz) % zs] = n
              end
            end
          end
        elsif ys > 0
          for y in 0...ys
            for x in 0...xs
              n = src_table[x, y]
              self[(x + nx) % xs, (y + ny) % ys] = n
            end
          end
        else
          for x in 0...xs
            n = src_table[x]
            self[(x + nx) % xs] = n
          end
        end
        return self
      end

      def nudge(*args)
        return dup.nudge!(*args)
      end

      def iterate
        to_enum(:iterate) unless block_given?
        if zs > 1
          for z in 0...zs
            for y in 0...ys
              for x in 0...xs
                n = src_table[x, y, z]
                yield n, x, y, z
              end
            end
          end
        elsif ys > 0
          for y in 0...ys
            for x in 0...xs
              n = src_table[x, y]
              yield n, x, y
            end
          end
        else
          for x in 0...xs
            n = src_table[x]
            yield n, x
          end
        end
        return self
      end

      [
        ['add', '+', '%s'],
        ['sub', '-', '%s'],
        ['mul', '*', '%s'],
        ['div', '/', '(%1$s == 0 ? 1 : %1$s)'],
        ['replace', '', '%s']
      ].each do |(word, sym, conv)|
        module_eval(%Q(
        def #{word}!(obj)
          case obj
          when Numeric
            iterate { |n, *coords| self[*coords] #{sym}= #{conv % 'obj'} }
          when TableEx
            if self.xsize != obj.xsize || self.ysize != obj.ysize || self.zsize != obj.zsize
              raise(ArgumentError,
                "Source TableEx must match dimensions of Target")
            end
            iterate do |n, *coords|
              num = obj[*coords]
              self[*coords] #{sym}= #{conv % 'num'}
            end
          else
            raise(TypeError,
              "expected type Numeric or TableEx but recieved #{'#{obj.class}'}")
          end
          return self
        end

        def #{word}(*args)
          return dup.#{word}!(*args)
        end
        ))
      end

      def inc!
        add!(1)
      end

      def dec!
        sub!(1)
      end

      def oor?(x, y=0, z=0)
        return true if x < 0 || y < 0 || z < 0
        return true if xsize <= x
        return true if ysize <= y if ysize > 0
        return true if zsize <= z if zsize > 0
        return false
      end

      alias :+ :add
      alias :- :sub
      alias :* :mul
      alias :/ :div

    end
  end
end
