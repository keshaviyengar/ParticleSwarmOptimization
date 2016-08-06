function cost = CamelBackFunction(pos)
  x = pos(1);
  y = pos(2);
  cost = ((4-2.1*x^2 + 1/3*x^4)*x^2 + x*y + (-4 + 4*y^2)*y^2);
end