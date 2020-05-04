function lab4()
    clc();

    a = -1;
    b = 0;
    epsilon = power(10, -6);
    n_GR = 2;
    
    % Draw graph function
    x = [-1 : 0.01 : 0];
    y = [];

    for i = x
        y = [y, func(i)];
    end
    
    plot(x, y), xlabel('x'), ylabel('func(x)'), title('Graph');
    grid on;

    hold on; 

    [x_star, f_star, n] = newton(a, b, epsilon, n_GR);
    fprintf('-------------------------------------\n');
    fprintf('epsilon: %f\n', epsilon);
    fprintf('x_star: %f\n', x_star);
    fprintf('f_star: %f\n', f_star);
    fprintf('N: %d\n', n);

    scatter(x_star, f_star, 200, 'g', 'x');

    hold off;

    [x, fval, ~, output] = fminbnd(@func, a, b);
    fprintf('\n======== FMINBND ========\n');
    fprintf('Number of iterations: %d\n', output.iterations);
    fprintf('Minimum point: (%7.8f, %7.8f)\n', x, fval);
end

% Input function
function y = func(x)
    y1 = (-power(x, 4) - 4 * power(x, 3) - 8 * x * x - 7 * x + 1) / sqrt(11);
    y2 = (4 * power(x, 5) - 4 * sqrt(10) * power(x, 4) + 8 * power(x, 3) + ...
        + 5 * x*x - 5 * sqrt(10) * x + 9) / (x*x - sqrt(10) * x + 2);
    y = sin(y1) + log10(y2);
    y = -y;
end

% Using Golden section search to find x
function [x_begin, x_middle, y_middle, x_end, n] = golden_step(a, b, n_GR)
    t = (sqrt(5) - 1) / 2;
    l = b - a;
    
    x1 = b - t*l;
    f1 = func(x1);
    
    x2 = a + t*l;
    f2 = func(x2);
    
    n = 2;

    for j = 1:n_GR
        if f1 <= f2
            b = x2;
            l = b - a;
            
            x2 = x1;
            f2 = f1;
            
            x_middle = x2;
            y_middle = f2;
            
            x1 = b - t*l;
            f1 = func(x1);
        else
            a = x1;
            l = b - a;
            
            x1 = x2;
            f1 = f2;
            
            x_middle = x1;
            y_middle = f1;
            
            x2 = a + t*l;
            f2 = func(x2);
        end
        n = n + 1;
    end
  
    x_begin = a;
    x_end = b;
end

% Source: https://ru.wikipedia.org/wiki/%D0%A7%D0%B8%D1%81%D0%BB%D0%B5%D0%BD%D0%BD%D0%BE%D0%B5_%D0%B4%D0%B8%D1%84%D1%84%D0%B5%D1%80%D0%B5%D0%BD%D1%86%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5
function f = derivative_1st(f1, f2, f3, eps)
    f = (-3*f1 + 4*f2 - f3) / 2 / eps;
end

function f = derivative_2nd(f1, f2, f3, eps)
    f = (f3 - 2*f2 + f1) / eps / eps;
end

% Newton method function
function [x_star, f_star, n] = newton(a, b, epsilon, n_GR)
    [x1, x2, f2, x3, n] = golden_step(a, b, n_GR);
    fprintf('After goldenratio step: N = %d\tSegment: [%.7f %.7f]\n', n, x1, x3);
    fprintf("Main process:\n");
    
    h = 1.0;
    plot([-1 0], [h h], 'Color', 'b');
    scatter([x1 x2 x3], [h h h], 200, 'b', 'x');

    x = x2;

    fprintf('Iteration %d: (%7.8f, %7.8f)\n', int8(n / 3), x, f2);
    scatter(x, f2, 'r', 'filled');
   
    flag = true;

    while flag
        f1 = func(x - epsilon);
        f2 = func(x);
        f3 = func(x + epsilon);

        n = n + 3;

        df = derivative_1st(f1, f2, f3, epsilon);

        if abs(df) <= epsilon
            flag = false;
        else
            ddf = derivative_2nd(f1, f2, f3, epsilon);
            x_mark = x;
            x = x_mark - df/ddf;

            fprintf('Iteration %d: (%7.8f, %7.8f)\n', int8(n / 3), x, func(x));
            scatter(x, func(x), 'r', 'filled');
        end
    end

    x_star = x;
    f_star = f2;
end