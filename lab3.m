function lab3()
    clc();

    a = -1;
    b = 0;
    epsilon = power(10, -6);
    n_GR = 6;
    
    % Draw graph function
    x = [-1 : 0.01 : 0];
    y = [];

    for i = x
        y = [y, func(i)];
    end
    
    plot(x, y), xlabel('x'), ylabel('func(x)'), title('Graph');
    grid on;

    hold on;

    [x_star, f_star, n] = parabol(a, b, epsilon, n_GR);
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
%    y1 = 2 * power(x, 5) - 7 * x + sqrt(11);
%    y2 = (-4*x*x - 4*x + 3 - 4*sqrt(2)) / (3*x*x + 3*x + 3*sqrt(2));
%    y = log(y1) + sinh(y2) - 1.0;
    y = (x + 0.777)^4;
end

% Using Golden section search to find x1, x2, x3
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

% Finding optimum point x
function x = optimum_point(x1, y1, x2, y2, x3, y3, epsilon)
    if abs(x1 - x3) > eps
        a1 = (y2 - y1) / (x2 - x1);
        a2 = ((y3 - y1)/(x3 - x1) - (y2 - y1)/(x2 - x1)) / (x3 - x2);

        x = (x1 + x2 - a1/a2) / 2;
    else
        x = (x1 + x3) / 2;
    end
end

% Parabol search function
function [x_star, f_star, n] = parabol(a, b, epsilon, n_GR)
    [x1, x2, y2, x3, n] = golden_step(a, b, n_GR);
    fprintf('After goldenratio step: N = %d\tSegment: [%.7f %.7f]\n', n, x1, x3);
    fprintf("Main process:\n");
    
    y1 = func(x1);
    y3 = func(x3);
    x = optimum_point(x1, y1, x2, y2, x3, y3, epsilon);
    
    n = n + 2;
    flag = true;
    h = 1.5;  % horizontal line begining
    
    % Check kind of function
    if (x1 - x) * (x3 - x) < 0
        y = func(x);
        n = n + 1;

        while flag
            % Draw horizontal line
            h = h - 0.1;
            plot([-1 0], [h h], 'Color', 'b');
            scatter([x1 x2 x3], [h h h], 200, 'b', 'x');
            scatter(x, h, 'r', 'filled');
          
            fprintf('N = %d\tSegment: [%.7f %.7f]\tCurrent: %f\n', n, x1, x3, x);
            scatter(x, y, 50, 'r', 'filled');
            
            x_mark = x;
            if (x < x2)
                if (y > y2)     % case: min \in [x, x3]
                    x1 = x;
                    y1 = y;
                else            % case: min \in [x1, x2]
                    x3 = x2;
                    y3 = y2;
                    x2 = x;
                    y2 = y;
                end
            else
                if (y >= y2)    % case: min \in [x1, x]
                    x3 = x;
                    y3 = y;
                else            % case: min \in [x2, x3]
                    x1 = x2;
                    y1 = y2;
                    x2 = x;
                    y2 = y;
                end
            end
            
            x = optimum_point(x1, y1, x2, y2, x3, y3, epsilon);
            y = func(x);
            n = n + 1;
            
            if abs(x - x_mark) < epsilon
                flag = false;
            end
        end
    else
        if (y1 < y3)
            x = x1;
            y = y1;
        else
            x = x3;
            y = y3;
        end
        
        % Draw horizontal line
        h = h - 0.1;
        plot([-1 0], [h h], 'Color', 'b');
        scatter([x1 x2 x3], [h h h], 200, 'b', 'x');
        scatter(x, h, 'r', 'filled');
    end
    
    x_star = x;
    f_star = y;
end
