function [ nll, dnll_x, dnll_W ] = loglinear_likelihood( x, W, i )
%LOGLINEAR_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

scores = W' * x;
scores_exp = exp(scores);
denom = logsumexp(scores);

nll = -(scores(i) - denom);
dnll_W = x * scores_exp' / sum(scores_exp);
dnll_W(:,i) = dnll_W(:,i) - x;
dnll_x = - W(:,i) + W * scores_exp / sum(scores_exp);

end

