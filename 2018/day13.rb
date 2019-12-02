#!/usr/bin/ruby

class Cart
  attr_accessor :x, :y, :xv, :yv, :t, :alive
  def initialize x, y, xv, yv
      @x = x
      @y = y
      @xv = xv
      @yv = yv
      @t = 0
      @alive = true
  end

  def live_cart_at?(x, y)
    self.x == x && self.y == y && self.alive
  end
end

carts = []
track = File.readlines('day13-input.txt').map.with_index do |line,y|
  line.chomp.chars.map.with_index do |char,x|
      case char
      when ?< then carts.push Cart.new(x,y,-1,0); ?-
      when ?> then carts.push Cart.new(x,y, 1,0); ?-
      when ?^ then carts.push Cart.new(x,y,0,-1); ?|
      when ?v then carts.push Cart.new(x,y,0, 1); ?|
      else char
      end
  end
end

loop {
  carts.sort_by!{|c| [c.y, c.x]}
  carts.each do |cart|
      next unless cart.alive

      cx = cart.x + cart.xv
      cy = cart.y + cart.yv
      crash = carts.find{|other_cart| other_cart.live_cart_at?(cx, cy)}
      if crash
          cart.alive = false
          crash.alive = false
          asf = carts.select{|asdf|asdf.alive}
          if asf.size == 1
              p asf[0].x
              p asf[0].y
              exit
          end
          next
      end
      cart.x = cx
      cart.y = cy

      case track[cart.y][cart.x]
      when '\\' then cart.xv, cart.yv = cart.yv, cart.xv
      when '/' then cart.xv, cart.yv = -cart.yv, -cart.xv
      when '+'
          case cart.t
          when 0 then cart.xv, cart.yv = cart.yv, -cart.xv
          when 1 #nop
          when 2 then cart.xv, cart.yv = -cart.yv, cart.xv
          end
          cart.t = (cart.t+1)%3
      end

  end
}