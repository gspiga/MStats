import os
import sys
import time
import math
import numpy
import matplotlib.pyplot as plt
import sklearn
import sklearn.datasets
import autograd.numpy as np
from numpy.linalg.linalg import matmul
from numpy.core.numeric import identity
import math
from numpy.core.numeric import identity

## Programming in 1-dimension
## f(x)=(ax-b)^2
## Gradient: 2a(ax-b)
## Hessian: 2a^2
def target_fun(a,b,x):
  return (a*x-b)**2
def zeroth_oracle(delta,x,a,b):
  return (target_fun(a,b,x+delta)-target_fun(a,b,x))/delta
def grad(a,b,x):
  return 2*a*(a*x-b)
def hes(a,b,x):
  return 2*a**2

## parameters a=2 b=10
a=2
b=10
x_star = b/a
T_tot = 1000
eta_rate = 0.02

def Zeroth_order_d1(T,eta):
## Initial point: x_0=0
  delta_zero=0.1
  x_prev = 0
  x_new = 0
  fun_error_list = []
  x_error_list = []
  for i in range(T):
    x_prev = x_new
    fun_error_list.append(abs(target_fun(a,b,x_prev)-target_fun(a,b,x_star)))
    x_error_list.append(abs(x_prev-x_star))
    ## update rule here
  return fun_error_list, x_error_list;

def Grad_descent_d1(T,eta):
## Initial point: x_0=0
  x_prev = 0
  x_new = 0
  fun_error_list = []
  x_error_list = []
  for i in range(T):
    x_prev = x_new
    fun_error_list.append(abs(target_fun(a,b,x_prev)-target_fun(a,b,x_star)))
    x_error_list.append(abs(x_prev-x_star))
    ## update rule here
  return fun_error_list, x_error_list;

def Second_order_d1(T,eta):
## Initial point: x_0=0
  x_prev = 0
  x_new = 0
  fun_error_list = []
  x_error_list = []
  for i in range(T):
    x_prev = x_new
    fun_error_list.append(abs(target_fun(a,b,x_prev)-target_fun(a,b,x_star)))
    x_error_list.append(abs(x_prev-x_star))
    ## update rule here
  return fun_error_list, x_error_list;

x_traj_zero, fun_traj_zero = Zeroth_order_d1(T_tot,eta_rate)
x_traj_first, fun_traj_first = Grad_descent_d1(T_tot,eta_rate)
x_traj_second, fun_traj_second = Second_order_d1(T_tot,eta_rate)

plt.rcParams["figure.figsize"] = [7.50, 5]
plt.rcParams["figure.autolayout"] = True
Trange = np.arange(T_tot)
plt.figure(1)
plt.subplot(211)
plt.plot(Trange, x_traj_zero, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|x_t-x^{*}|$')
plt.subplot(212)
plt.plot(Trange, fun_traj_zero, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|f(x_t)-f(x^{*})|$')

plt.rcParams["figure.figsize"] = [7.50, 5]
plt.rcParams["figure.autolayout"] = True
Trange = np.arange(T_tot)
plt.figure(1)
plt.subplot(211)
plt.plot(Trange, x_traj_first, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|x_t-x^{*}|$')
plt.subplot(212)
plt.plot(Trange, fun_traj_first, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|f(x_t)-f(x^{*})|$')

plt.rcParams["figure.figsize"] = [7.50, 5]
plt.rcParams["figure.autolayout"] = True
Trange = np.arange(T_tot)
plt.figure(1)
plt.subplot(211)
plt.plot(Trange, x_traj_second, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|x_t-x^{*}|$')
plt.subplot(212)
plt.plot(Trange, fun_traj_second, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|f(x_t)-f(x^{*})|$')

## Programming in d-dimension
## f(x)=(Ax-b)^T(Ax-b)
## Gradient: 2A^T(Ax-b)
## Hessian: 2A^TA
def target_fun_p(A,b,x):
  return (A@x-b).T@(A@x-b)
def zeroth_oracle_p(delta,vec,x,A,b):
  return ((target_fun_p(A,b,x+delta*vec)-target_fun_p(A,b,x))/delta)*vec
def grad_p(A,b,x):
  return 2*A.T@(A@x-b)
def hes_p(A,b,x):
  return 2*A.T@A

## parameters
A=np.array([[2,4],[1,1],[10,2]])
b=np.array([[100],[200],[300]])
x_star = np.linalg.inv(A.T@A)@A.T@b
T_tot = 1000
eta_rate = 0.005

def Zeroth_order_dl_p(T,eta):
## Initial point: x_0=0
  delta_zero=0.1
  x_prev = np.array([[0],[0]])
  x_new = np.array([[0],[0]])
  fun_error_list = []
  x_error_list = []
  evec = np.array([[1],[1]])
  for i in range(T):
    x_prev = x_new
    fun_error_list.append(np.linalg.norm(target_fun_p(A,b,x_prev)-target_fun_p(A,b,x_star)))
    x_error_list.append(np.linalg.norm(x_prev-x_star))
    ## update rule here
  return fun_error_list, x_error_list;

def Grad_descent_d1_p(T,eta):
## Initial point: x_0=0
  x_prev = np.array([[0],[0]])
  x_new = np.array([[0],[0]])
  fun_error_list = []
  x_error_list = []
  for i in range(T):
    x_prev = x_new
    fun_error_list.append(np.linalg.norm(target_fun_p(A,b,x_prev)-target_fun_p(A,b,x_star)))
    x_error_list.append(np.linalg.norm(x_prev-x_star))
    ## update rule here
  return fun_error_list, x_error_list;

def Second_order_d1_p(T,eta):
## Initial point: x_0=0
  x_prev = np.array([[0],[0]])
  x_new = np.array([[0],[0]])
  fun_error_list = []
  x_error_list = []
  for i in range(T):
    x_prev = x_new
    fun_error_list.append(np.linalg.norm(target_fun_p(A,b,x_prev)-target_fun_p(A,b,x_star)))
    x_error_list.append(np.linalg.norm(x_prev-x_star))
    ## update rule here
  return fun_error_list, x_error_list;

x_traj_zero_p, fun_traj_zero_p = Zeroth_order_dl_p(T_tot,eta_rate)
x_traj_first_p, fun_traj_first_p = Grad_descent_d1_p(T_tot,eta_rate)
x_traj_second_p, fun_traj_second_p = Second_order_d1_p(T_tot,eta_rate)

plt.rcParams["figure.figsize"] = [7.50, 5]
plt.rcParams["figure.autolayout"] = True
Trange = np.arange(T_tot)
plt.figure(1)
plt.subplot(211)
plt.plot(Trange, x_traj_zero_p, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|x_t-x^{*}|$')
plt.subplot(212)
plt.plot(Trange, fun_traj_zero_p, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|f(x_t)-f(x^{*})|$')

plt.rcParams["figure.figsize"] = [7.50, 5]
plt.rcParams["figure.autolayout"] = True
Trange = np.arange(T_tot)
plt.figure(1)
plt.subplot(211)
plt.plot(Trange, x_traj_first_p, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|x_t-x^{*}|$')
plt.subplot(212)
plt.plot(Trange, fun_traj_first_p, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|f(x_t)-f(x^{*})|$')

plt.rcParams["figure.figsize"] = [7.50, 5]
plt.rcParams["figure.autolayout"] = True
Trange = np.arange(T_tot)
plt.figure(1)
plt.subplot(211)
plt.plot(Trange, x_traj_second_p, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|x_t-x^{*}|$')
plt.subplot(212)
plt.plot(Trange, fun_traj_second_p, color = 'red')
plt.xlabel(r'$T$')
plt.ylabel(r'Error $|f(x_t)-f(x^{*})|$')