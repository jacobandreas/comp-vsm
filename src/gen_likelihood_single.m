function [ nll, dnll ] = gen_likelihood_single( adj, noun, pair, ...
                                                noise, theta_adj, ...
                                                theta_noun, i_adj, ...
                                                i_noun )
%GEN_LIKELIHOOD_SINGLE Summary of this function goes here
%   Detailed explanation goes here

[ nll_adj, dnll_adj__pair, dnll_adj__theta_adj ] = ...
    loglinear_likelihood(pair, theta_adj, i_adj);


% noun | pair, adj

pred_noun = adj * pair;
diff = pred_noun - noun;
nll_nm = (diff' * diff) / (2 * noise);
dnll_nm__pair = adj * diff / noise;
dnll_nm__noun = - diff / noise;
dnll_nm__noise = - nll_nm / noise;
dnll_nm__adj = diff * pair' / noise;

% noun | noun

[ nll_noun, dnll_noun__noun, dnll_noun__theta_noun ] = ...
    loglinear_likelihood(noun, theta_noun, i_noun);

nll = nll_adj + nll_nm + nll_noun;
dnll = [];
dnll.pair = dnll_adj__pair + dnll_nm__pair;
dnll.noun = dnll_nm__noun + dnll_noun__noun;
dnll.adj = dnll_nm__adj;
dnll.noise = dnll_nm__noise;
dnll.theta_adj = dnll_adj__theta_adj;
dnll.theta_noun = dnll_noun__theta_noun;

end

