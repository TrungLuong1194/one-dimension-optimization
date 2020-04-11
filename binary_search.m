function binary_search()
  clc();
  
  a = -1;
  b = 0;
  epsilon = power(10, -6);
  
  % Draw graph function
  x = [-1 : 0.01 : 0];
  y = [];
  for i = x
    y = [y, func(i)];
  end
  plot(x, y), xlabel('x'), ylabel('func(x)'), title('Graph')
  
  hold on;
  
  [x_star, f_star, countIter] = binary(a, b, epsilon);
  fprintf('-------------------------------------\n');
  fprintf('epsilon: %f\n', epsilon);
  fprintf('x_star: %f\n', x_star);
  fprintf('f_star: %f\n', f_star);
  fprintf('Number of iteration: %d\n', countIter);
  
  plot(x_star, f_star, 'Color', 'g', 'MarkerSize', 25);

  hold off;
end

% Input function
function y = func(x)
  y1 = 2 * power(x, 5) - 7 * x + sqrt(11);
  y2 = (-4*x*x - 4*x + 3 - 4*sqrt(2)) / (3*x*x + 3*x + 3*sqrt(2));
  y = log(y1) + sinh(y2) - 1.0;
end

% Binary search function
function [x_star, f_star, countIter] = binary(a, b, epsilon)
  delta = (b-a)/2;
  x0 = a;
  f0 = func(x0);
  countIter = 1;
  flag = true;
  
  fprintf('N = %d\tdelta = %.9f\t(x0, f0) = (%.9f, %.9f)\n', countIter, delta, x0, f0);
  plot(x0, f0, 'Marker', '.', 'Color', 'r', 'MarkerSize', 25);
  
  while flag
    countIter = countIter + 1;
    x1 = x0 + delta;
    f1 = func(x1);
    
    fprintf('N = %d\tdelta = %.9f\t(x0, f0) = (%.9f, %.9f)\t(x1, f1) = (%.9f, %.9f)\n', countIter, delta, x0, f0, x1, f1);
    plot(x0, f0, 'Marker', '.', 'Color', 'r', 'MarkerSize', 25);
    
    if f0 > f1
      x0 = x1;
      f0 = f1;
      
      if a < x0 && x0 < b
        continue;
      end
    end
      
    if abs(delta) <= epsilon
      flag = false;
    else
      x0 = x1;
      f0 = f1;
      delta = -delta/2;
    end
  end
  
  x_star = x0;
  f_star = f0;
end
