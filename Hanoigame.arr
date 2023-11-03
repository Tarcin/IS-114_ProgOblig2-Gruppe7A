rod = circle(5, "solid", "black")
red-c = circle(20,"solid","red")
green-c = circle(30,"solid","green")
blue-c = circle(40,"solid","blue")
orange-c = circle(50,"solid","orange")
box = empty-scene(400,120)

var l-rod = rod
var m-rod = rod
var r-rod = rod

hanoi = [array: 1, 1, 1, 1]
circle-list = [list: red-c, green-c, blue-c, orange-c]

#|fun move(location :: Number, destination :: Number):
end|#

fun build-rods(index :: Number):
  temp = hanoi.get-now(index)
  block:  
        if temp == 1:
          l-rod := overlay(l-rod, circle-list.get(index))
        else if temp == 2:
          m-rod := overlay(m-rod, circle-list.get(index))
        else: 
          r-rod := overlay(r-rod, circle-list.get(index))
        end
  if index < 3: 
      build-rods(index + 1)
    else:
      "returning..."
  end
  end
end

fun hanoi-state():
  block:
  build-rods(0)
  step-1 = put-image(l-rod, 100, 60, box)
  step-2 = put-image(m-rod, 200, 60, step-1)
  step-3 = put-image(r-rod, 300, 60, step-2)
  step-3
  end
end
