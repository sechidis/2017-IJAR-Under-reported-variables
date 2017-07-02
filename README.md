# IJAR 2017 - Dealing with under-reported variables: An information theoretic solution

Matlab code for the methods presented in:

K. Sechidis, M. Sperrin, E. S. Petherick, M. Luján, G. Brown, Dealing with under-reported variables: An information theoretic solution, International Journal of Approximate Reasoning, Volume 85, June 2017, Pages 159-177. <br /> http://www.sciencedirect.com/science/article/pii/S0888613X17302335

## Estimating mutual information in under-reported scenarios (Section 4)
The code implements our two methods:
* urMI1.m - Implements the corrected mutual information that captures relevancy presented in Definition 1, and it also returns the standard error presented in Theorem 3.
* urMI2.m - Implements the corrected mutual information that captures redundancy presented in Definition 2. 


## Ranking features in under-reported scenarios (Section 5)
The code implements our two methods:
* correctedMIM.m - Rankings that Capture Only Relevancy (Section 5.1).
* correctedMRMR.m - Rankings that Capture both Relevancy and Redundancy (Section 5.2).

## Tutorial
The tutorial 'Tutorial_UR_FS.m' presents how to select features using  our suggested methods for correcting the under-reporting bias.

## Citation

If you make use of the code found here, please cite the paper above.

@article{sechidis2017underreported,<br />
title = {Dealing with under-reported variables: An information theoretic solution},<br />
journal = {International Journal of Approximate Reasoning},<br />
volume = 85,<br />
pages = {159 - 177},<br />
year = 2017,<br />
author = {Konstantinos Sechidis and Matthew Sperrin and Emily S. Petherick and Mikel Luj\'an and Gavin Brown},<br />
} 
