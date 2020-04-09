function golden_section_search()
  clc();
  
  a = -1;
  b = 0;
  list_x_star = [];
  list_f_star = [];
  % Output x_star, f_star
  for epsilon = [10.^-2, 10.^-4, 10.^-6]
    [x_star, f_star, countIter] = golden(a, b, epsilon);
    list_x_star = [list_x_star, x_star];
    list_f_star = [list_f_star, f_star];
    fprintf('epsilon: %f\n', epsilon);
    fprintf('x_star: %f\n', x_star);
    fprintf('f_star: %f\n', f_star);
    fprintf('Number of iteration: %d\n', countIter);
    fprintf('-------------------------------------\n');
  end
  
  % Draw graph function
  x = [-1 : 0.01 : -0.02];
  y = [];
  for i = x
    y = [y, func(i)];
  end
  scatter(x, y, 'filled'), xlabel('x'), ylabel('func(x)'), title('Graph')
  
  hold on

  scatter(list_x_star, list_f_star, 'r', 'filled'), legend('(x,f(x))', '(x*,f(x*))')

  hold off
end

% Input function
function value = func(x)
  value = log(2*(x.^5) - 7*x + sqrt(11)) + ...
  sinh((-4*(x.^2) - 4*x + 3 - 4*sqrt(2)) / (3*(x.^2) + 3*x + 3*sqrt(2))) - 1.0;
end

% Binary search function
function [x_star, f_star, countIter] = golden(a, b, epsilon)
  countIter = 0;
  gr = (sqrt(5) - 1) / 2;
  x1 = b - gr*(b-a);
  x2 = a + gr*(b-a);
  
  while abs(b - a) >= epsilon
    countIter = countIter + 1;
    if func(x1) < func(x2)
      a = a;
      b = x2;
      x2 = x1;
      x1 = b - gr*(b-a);
    else
      a = x1;
      b = b;
      x1 = x2;
      x2 = a + gr*(b-a);
    end
  end
  
  x_star = (a + b) / 2;
  f_star = func(x_star);
end
