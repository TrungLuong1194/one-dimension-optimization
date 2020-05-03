function lab2()
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

    [x_star, f_star, countIter] = golden(a, b, epsilon);
    fprintf('-------------------------------------\n');
    fprintf('epsilon: %f\n', epsilon);
    fprintf('x_star: %f\n', x_star);
    fprintf('f_star: %f\n', f_star);
    fprintf('Number of iteration: %d\n', countIter);

    scatter(x_star, f_star, 200, 'g', 'x');

    hold off;
end

% Input function
function y = func(x)
    y1 = 2 * power(x, 5) - 7 * x + sqrt(11);
    y2 = (-4*x*x - 4*x + 3 - 4*sqrt(2)) / (3*x*x + 3*x + 3*sqrt(2));
    y = log(y1) + sinh(y2) - 1.0;
end

% Golden section search function
function [x_star, f_star, countIter] = golden(a, b, epsilon)
    countIter = 1;
    t = (sqrt(5) - 1) / 2;
    l = b - a;
    x1 = b - t*l;
    f1 = func(x1);
    x2 = a + t*l;
    f2 = func(x2);

    fprintf('N = %d\tl = %d\t(x1, f1) = (%.9f, %.9f)\t(x2, f2) = (%.9f, %.9f)\n',...
    countIter, l, x1, f1, x2, f2);

    while l > 2*epsilon
        countIter = countIter + 1;
        if f1 <= f2
            b = x2;
            l = b - a;
            x2 = x1;
            f2 = f1;
            x1 = b - t*l;
            f1 = func(x1);
        else
            a = x1;
            l = b - a;
            x1 = x2;
            f1 = f2;
            x2 = a + t*l;
            f2 = func(x2);
        end
        
        fprintf('N = %d\tl = %d\t(x1, f1) = (%.9f, %.9f)\t(x2, f2) = (%.9f, %.9f)\n', countIter, l, x1, f1, x2, f2);
        scatter(x1, f1, 50, 'r', 'filled');
    end
  
    x_star = (a + b) / 2;
    f_star = func(x_star);
end