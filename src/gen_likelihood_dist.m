function [ nll, uw_dnll ] = gen_likelihood_dist( uw_params, consts, ...
                                                 options, sample_params )
%LIKELIHOOD_DIST Summary of this function goes here
%   Detailed explanation goes here

p = rewrap(sample_params, uw_params);

nll = 0;
dnll = [];
dnll.adjs = zeros(size(p.adjs));
dnll.noise = 0;
dnll.theta_adj = zeros(size(p.theta_adj));
dnll.theta_noun = zeros(size(p.theta_noun));

for i=1:consts.n_pairs
    i_adj = consts.pairs(i,1);
    i_noun = consts.pairs(i,2);
    i_pair = consts.pairs(i,3);
    
    
    if options.gen.tie_adjs
        adj = p.adjs;
    else
        adj = p.adjs(:,:,i_adj);
    end
    noun = consts.vectors.nouns(i_noun,:)';
    pair = consts.vectors.pairs(i_pair,:)';
    
    [nll_single, dnll_single] = gen_likelihood_single(adj, ...
                                                      noun, ...
                                                      pair, ...
                                                      p.noise, ...
                                                      p.theta_adj, ...
                                                      p.theta_noun, ...
                                                      i_adj, ...
                                                      i_noun);
                                                  
    nll = nll + nll_single;
    if options.gen.tie_adjs
        dnll.adjs = dnll.adjs + dnll_single.adj;
    else
        dnll.adjs(:,:,i_adj) = dnll.adjs(:,:,i_adj) + dnll_single.adj;
    end
    dnll.noise = dnll.noise + dnll_single.noise;
    dnll.theta_adj = dnll.theta_adj + dnll_single.theta_adj;
    dnll.theta_noun = dnll.theta_noun + dnll_single.theta_noun;              
end

% TODO regularization

uw_dnll = unwrap(dnll);

end