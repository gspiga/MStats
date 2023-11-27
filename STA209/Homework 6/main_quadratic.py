######
######  This script compares different optimization methods on optimizating
######  a quadratic function of the form f(x) = 1/2 * x'Hx + x'b 
######
%matplotlib inline
import numpy as np
import hw6_functions as hw
import algorithms as alg


# the hessian matrix of the quadratic function
H = np.matrix('1 0; 0 30')

# the vector of linear coefficient of the quadratic function
b = np.matrix('0; 0')

# Choose the quadratic objective. This notation defines a "closure", returning
# an oracle function which takes x (and order) as its only parameter, and calls
# obj.quadratic with parameters H and b defined above, and the parameters of 
# the closure (x and order)
func = lambda x, order: hw.quadratic( H, b, x, order )


# Start at (4,0.3), with an identity inverse Hessian
initial_x = np.matrix('4; 0.3')
initial_inverse_hessian = np.eye( 2 )
# Find the (1e-4)-suboptimal solution
eps = 1e-4
maximum_iterations = 65536

# Run the algorithms
x, values, runtimes, gd_xs = alg.gradient_descent( func, initial_x, eps, maximum_iterations, alg.bisection )

x, values, runtimes, newton_xs = alg.newton( func, initial_x, eps, maximum_iterations, alg.bisection )

# Draw contour plots
hw.draw_contour( func, gd_xs, newton_xs, levels=np.arange(5, 400, 20), x=np.arange(-5, 5.1, 0.1), y=np.arange(-5, 5.1, 0.1) )
