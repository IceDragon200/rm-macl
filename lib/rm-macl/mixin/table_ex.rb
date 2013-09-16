#
# RGSS3-MACL/lib/mixin/table-ex.rb
#   by IceDragon
#   dc 03/03/2013
#   dm 21/04/2013
# vr 2.2.0
module MACL
  module Mixin
    module TableEx

      class TableError < RuntimeError
      end

      ##
      # xp - X-Plus
      # xm - X-Minus
      # yp - Y-Plus
      # ym - Y-Minus
      # zp - Z-Plus
      # zm - Z-Minus
      FillRule = Struct.new(:xp, :xm, :yp, :ym, :zp, :zm)
      FILL_ALL = FillRule.new(true, true, true, true, true, true).freeze

      def iterate
        to_enum(:iterate) unless block_given?
        if zsize > 1
          zsize.times do |z|
            ysize.times do |y|
              xsize.times do |x|
                n = self[x, y, z]
                yield n, x, y, z
              end
            end
          end
        elsif ys > 0
          ysize.times do |y|
            xsize.times do |x|
              n = self[x, y]
              yield n, x, y
            end
          end
        else
          xsize.times do |x|
            n = self[x]
            yield n, x
          end
        end
        return self
      end

      ##
      # nudge!(int nx, int ny, int nz)
      #   Moves data in the table relatively
      def nudge!(nx, ny, nz)
        src_table = self.dup
        xs, ys, zs = tabclone.xsize, tabclone.ysize, tabclone.zsize
        if zs > 1
          iterate do |n, x, y, z|
            self[(x + nx) % xs, (y + ny) % ys, (z + nz) % zs] = n
          end
        elsif ys > 0
          iterate do |n, x, y|
            self[(x + nx) % xs, (y + ny) % ys] = n
          end
        else
          iterate do |n, x|
            self[(x + nx) % xs] = n
          end
        end
        return self
      end

      def nudge(*args)
        return dup.nudge!(*args)
      end

      [
        ['add', '+', '%s'],
        ['sub', '-', '%s'],
        ['mul', '*', '%s'],
        ['div', '/', '(%1$s == 0 ? 1 : %1$s)'],
        ['fill', '', '%s']
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

      def inc!(n=1)
        add!(n)
      end

      def dec!(n=1)
        sub!(n)
      end

      ##
      # oor?(Integer x)                       |
      # oor?(Integer x, Integer y)            |
      # oor?(Integer x, Integer y, Integer z) |-> Boolean
      def oor?(x, y=0, z=0)
        return true if x < 0 || y < 0 || z < 0
        return true if xsize <= x
        return true if ysize <= y if ysize > 0
        return true if zsize <= z if zsize > 0
        return false
      end

      ##
      # bound_in_rect(Rect rect) -> Rect
      def bound_in_rect(rect)
        result = rect
        if rect.x < 0
          result.width = rect.width - rect.x
          result.x = 0
        end
        if rect.y < 0
          result.height = result.height - rect.y
          result.y = 0
        end
        if rect.width > xsize
          result.width = xsize
        end
        if rect.height > ysize
          result.height = ysize
        end
        return result
      end

      ##
      # fill_rect(Rect rect, Integer n)            |
      # fill_rect(Rect rect, Integer n, Integer z) |-> nil
      def fill_rect(rect, n, z=0)
        if self.dimension == 1
          raise(TableError,
                "#fill_rect can only be used with a 2D or 3D table")
        end
        r = bound_in_rect(rect.dup)
        return if r.empty?
        if self.dimension == 2
          for y in r.y...r.y2
            for x in r.x...r.x2
              self[x, y] = n
            end
          end
        else
          for y in r.y...r.y2
            for x in r.x...r.x2
              self[x, y, z] = n
            end
          end
        end
        self
      end

      ##
      # clear_rect(Rect rect)            |
      # clear_rect(Rect rect, Integer z) |-> nil
      def clear_rect(rect, z=0)
        fill_rect(rect, 0, z)
      end

      def bucket_fill1(x, n, fill_rule=FILL_ALL, src=nil)
        src ||= self[x]
        return if src == n
        ix = x
        while (ix < xsize)
          self[ix] == src ? self[ix] = n : break
          ix += 1
        end if fill_rule.xp

        ix = x - 1
        while (ix >= 0)
          self[ix] == src ? self[ix] = n : break
          ix -= 1
        end if fill_rule.xm
        self
      end

      def bucket_fill2(x, y, n, fill_rule=FILL_ALL, src=nil)
        src ||= self[x, y]
        return if src == n
        if self[x, y] == src
          self[x, y] = n
          bucket_fill2(x, y + 1, n, fill_rule, src) if fill_rule.yp && !oor?(x, y + 1)
          bucket_fill2(x + 1, y, n, fill_rule, src) if fill_rule.xp && !oor?(x + 1, y)
          bucket_fill2(x, y - 1, n, fill_rule, src) if fill_rule.ym && !oor?(x, y - 1)
          bucket_fill2(x - 1, y, n, fill_rule, src) if fill_rule.xm && !oor?(x - 1, y)
        end
        self
      end

      def bucket_fill3(x, y, z, n, fill_rule=FILL_ALL, src=nil)
        src ||= self[x, y, z]
        return if src == n
        if self[x, y, z] == src
          self[x, y, z] = n
          bucket_fill3(x, y, z + 1, n, fill_rule) if fill_rule.zp && !oor?(x, y, z + 1)
          bucket_fill3(x, y + 1, z, n, fill_rule) if fill_rule.yp && !oor?(x, y + 1, z)
          bucket_fill3(x + 1, y, z, n, fill_rule) if fill_rule.xp && !oor?(x + 1, y, z)
          bucket_fill3(x, y, z - 1, n, fill_rule) if fill_rule.zm && !oor?(x, y, z - 1)
          bucket_fill3(x, y - 1, z, n, fill_rule) if fill_rule.ym && !oor?(x, y - 1, z)
          bucket_fill3(x - 1, y, z, n, fill_rule) if fill_rule.xm && !oor?(x - 1, y, z)
        end

        self
      end

      def rect
        return Rect.new(0, 0, xsize, ysize)
      end

      def cube
        return MACL::Cube.new(0, 0, 0, xsize, ysize, zsize)
      end

      alias :+ :add
      alias :- :sub
      alias :* :mul
      alias :/ :div
      alias :to_rect :rect
      alias :to_cube :cube

      private :bound_in_rect

    end
  end
end
