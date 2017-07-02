function [MI stdErrorMI] = urMI1(y, xUR, gamma_x)
% Summary
%    Estimate the mutual information between variable y and an
%    under-reported feature xUR (Definition 1), and also returns
%    the standard error of the estimator.
% Inputs:
%    y: n x 1 vector with a correctly reported values for Y
%    xUR: n x 1 vector with the under-reported values of X
%    gamma_x: user's prior belief over the prevelance p(x=1)


epsilon =  10^(-50);

Y_given_Xur1 = y(xUR==1);

yvals = unique(y); %arity of X variable

pY = arrayfun(@(x)length(find(y==x)), unique(yvals)) / length(y);

pY(pY==0) = epsilon;%

pY_given_Xur1 = arrayfun(@(x)length(find(Y_given_Xur1==x)), unique(yvals)) / length(Y_given_Xur1);

pXur1 = length(Y_given_Xur1)/length(y);

pYX1 = pY_given_Xur1*gamma_x;

pYX0 = max(pY-pYX1,epsilon); % when it is negative

MIX1 = sum(pYX1.*log(epsilon+pYX1./(pY*gamma_x)));

MIX0 = sum(pYX0.*log(epsilon+pYX0./(pY*(1-gamma_x))));

MI = MIX1+MIX0;

pYXur1 = pY_given_Xur1*pXur1;

PYXur0 = abs(pY-pYXur1);

ph_xs_neg = log(epsilon+pYX0./pY);

ph_xs_pos = log(epsilon+pYX0./pY) - gamma_x/pXur1 * log(epsilon+pYX0./pYX1) + gamma_x/pXur1 * sum(pY_given_Xur1.*log(epsilon+pYX0./pYX1)) ;

variance = sum(pYXur1.*ph_xs_pos.^2 + PYXur0.*ph_xs_neg.^2) -(sum(pYXur1.*ph_xs_pos + PYXur0.*ph_xs_neg))^2;

stdErrorMI = sqrt(variance/length(y));
