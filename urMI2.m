function MI = urMI2(zUR, xUR, gamma_z, gamma_x)
% Summary
%    Estimate the mutual information between two under-reported
%    features zUR and an xUR (Definition 2)
% Inputs
%    zUR: n x 1 vector with the under-reported values of Z
%    xUR: n x 1 vector with the under-reported values of X
%    gamma_z: user's prior belief over the prevelance p(z=1)
%    gamma_x: user's prior belief over the prevelance p(x=1)

epsilon =  10^(-50);

pXur1 = sum(xUR==1)/length(xUR);

pZur1 = sum(zUR==1)/length(zUR);

pXur1Zur1 = sum( (xUR==1) .* (zUR==1) )/length(xUR);

term1 = gamma_z * gamma_x * pXur1Zur1/(pXur1*pZur1) *log(epsilon + pXur1Zur1/(pXur1*pZur1));

numer_term2 = max(pXur1*pZur1 - gamma_x * pXur1Zur1,epsilon);
term2 = ((gamma_z*numer_term2)/(pXur1*pZur1))*log(numer_term2/((1-gamma_x)*pXur1*pZur1));

numer_term3 = max(pXur1*pZur1 - gamma_z * pXur1Zur1,epsilon);
term3 = ((gamma_x*numer_term3)/(pXur1*pZur1))*log(numer_term3/((1-gamma_z)*pXur1*pZur1));

numer_term4 = max((1-gamma_x-gamma_z)*pXur1*pZur1 +gamma_x* gamma_z * pXur1Zur1,epsilon);
term4 = (numer_term4/(pXur1*pZur1))*log(numer_term4/((1-gamma_x)*(1-gamma_z)*pXur1*pZur1));

MI = term1 + term2 + term3 + term4;

