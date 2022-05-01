clear;
clc;
close all;

n = 1.2e7;
m = 2e4;
k = 2:100;

e = 1 + 1 ./ k - (1 - m / n) .^ k;

plot(k, n * e);
title('核酸检测次数随混合检测每组的人数的变化');
xlabel('混合检测每组的人数');
ylabel('核酸检测次数');