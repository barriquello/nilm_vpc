%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rearrange_dost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% rearrange the dost coefficients of a given 1-dimensional 
% signal in a matrix which resembles the classical time-frequency plane. 
%
% Remark: let v be te analized time_series, i.e. a vector of length N, 
% then dost(v) is still a vector of length N. In fact, the dost is just 
% a change of basis (as, for example, the fft). Nevertheless, the 
% coefficients of v with respect to this basis have a time-frequency
% meaning. rearrange_dost takes these coefficients and rearrange them in a
% matrix resembling the time-frequency plane.
%
% Example:
% v = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
% Then rearrange_dost(v) is the following  (16,16)-matrix:
%
%     13    13    13    13    14    14    14    14    15    15    15    15    16    16    16    16
%     13    13    13    13    14    14    14    14    15    15    15    15    16    16    16    16
%     13    13    13    13    14    14    14    14    15    15    15    15    16    16    16    16
%     13    13    13    13    14    14    14    14    15    15    15    15    16    16    16    16
%     11    11    11    11    11    11    11    11    12    12    12    12    12    12    12    12
%     11    11    11    11    11    11    11    11    12    12    12    12    12    12    12    12
%     10    10    10    10    10    10    10    10    10    10    10    10    10    10    10    10
%      9     9     9     9     9     9     9     9     9     9     9     9     9     9     9     9
%      8     8     8     8     8     8     8     8     8     8     8     8     8     8     8     8
%      6     6     6     6     6     6     6     6     7     7     7     7     7     7     7     7
%      6     6     6     6     6     6     6     6     7     7     7     7     7     7     7     7
%      2     2     2     2     3     3     3     3     4     4     4     4     5     5     5     5
%      2     2     2     2     3     3     3     3     4     4     4     4     5     5     5     5
%      2     2     2     2     3     3     3     3     4     4     4     4     5     5     5     5
%      2     2     2     2     3     3     3     3     4     4     4     4     5     5     5     5
%      1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
%
% Remark: 
% this matrix of indices is sligthly different from the one given in 
% [3] and [4]. 
%
% For more informations on the dost see the dost code
%
% Code by: U. Battisti and L. Riba 
% July, 02 2014
%
% References:
% [1]   R.G. Stockwell, "Why use the S-Transform", Pseudo-differential 
%       operators partial differential equations and time-frequency 
%       analysis, vol. 52 Fields Inst. Commun., pages 279--309, 
%       Amer. Math. Soc., Providence, RI 2007;
% [2]   R.G. Stockwell, "A basis for efficient representation of the
%       S-transform", Digital Signal Processing, 17: 371--393, 2007;
% [3]   Y. Wang and J. Orchard, "Fast-discrete orthonormal 
%       Stockwell transform", SISC: 31:4000--4012, 2009;
% [4]   Y. Wang, "Efficient Stockwell transform with applications to 
%       image processing", PhD thesis, University of Waterloo, 
%       Ontario Canada, 2011;
% [5]   U. Battisti, L.Riba, "Window-dependent bases for efficient 
%       representation of the Stockwell transform", 2014
%       http://arxiv.org/abs/1406.0513.
%
% Inputs:
% "dost_coefficients" - vector of the dost_coefficienst to be visualized
%
% Outputs:
% "matrix_dost_coefficients"    - the matrix of the dost coefficients. 
%                                 Rows  represents frequencies and columns 
%                                 represents times as common usage in the literature.
%
%
% Additional details:
% Copyright (c) by U. Battisti and L. Riba
% $Revision: 1.0 $  
% $Date: 2014/07/02  $


function matrix_dost_coefficients = rearrange_dost(dost_coefficients)

N = length (dost_coefficients);

% compute the frequency bands using the same function as in dost 
% (more informations below)
[~ , freq_band_widths] = band_width_partitioning(N);
% compute the time bands
time_band_widths = N./freq_band_widths;

% initizialize the output;
matrix_dost_coefficients = zeros(N,N);

kk = 1;
ii = 1;

counter = 1;

% initialize a matrix of indices (see the example above)
matrix_of_indices = zeros(N,N);

for hh = freq_band_widths
        for jj =N:-time_band_widths(kk):1
           row_index = N - ii+1 - hh +1;
           column_index = abs(N-jj)+1;
           si = size( matrix_of_indices(row_index : row_index + hh - 1, column_index : column_index + time_band_widths(kk) - 1 )) ;
           matrix_of_indices(row_index : row_index + hh - 1, column_index : column_index + time_band_widths(kk) - 1 ) = counter (ones(si));  
           counter = counter + 1;
        end
        kk = kk+1;
        ii = ii + hh;  
end

matrix_dost_coefficients = dost_coefficients(matrix_of_indices);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% band_width_partitioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dyadic partioning of the frequencies, example:
% samples = 16,
% number_of_freq_band = 10;
% band_widths = [1, 4, 2, 1, 1, 1, 2, 4].
% 
% Inputs:
% "samples" - length of the 1-dimensional signal we are analyzing;
%
% Outputs:
% "number_of_freq_bands"  - number of different frequency band on which we 
%                           are partitioning the time-frequency space; 
% "band_widths"           - vector (of length number_of_freq_bands) of all 
%                           the frequency bandwidths. The bandwidths are
%                           ordered from negative to positive frequencies.
%
function [number_of_freq_bands, band_widths] = band_width_partitioning(samples)

max_band_width_exponent = log2(samples)-2;
positive_band_width_exponents = 0:max_band_width_exponent;
band_width_powers =[0,fliplr(positive_band_width_exponents),0,positive_band_width_exponents];

band_widths = 2.^band_width_powers;
number_of_freq_bands = length(band_widths);
end
