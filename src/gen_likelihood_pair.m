function [ nll, uw_dnll ] = gen_likelihood_pair( uw_params, consts, ...
                                                 options, sample_params )
%LIKELIHOOD_DIST Summary of this function goes here
%   Detailed explanation goes here

p = rewrap(sample_params, uw_params);

nll = 0;
dnll = [];
dnll.adjs = zeros(size(p.adjs));
dnll.pairs = zeros(size(p.pairs));
dnll.noise = 0;
dnll.theta_adj = zeros(size(p.theta_adj));
dnll.theta_noun = zeros(size(p.theta_noun));

for i_sim=1:consts.n_sims
    sim_i_pairs = consts.sims{i_sim};
    sim_n_pairs = size(sim_i_pairs,1);
    latent_pair = p.pairs(i_sim,:)';
    
    for sim_i_pair=1:sim_n_pairs
        i_adj = sim_i_pairs(sim_i_pair,1);
        i_noun = sim_i_pairs(sim_i_pair,2);

        adj = p.adjs(:,:,i_adj);
        noun = consts.vectors(i_noun,:)';

        [nll_single, dnll_single] = gen_likelihood_single(adj, ...
                                                          noun, ...
                                                          latent_pair, ...
                                                          p.noise, ...
                                                          p.theta_adj, ...
                                                          p.theta_noun, ...
                                                          i_adj, ...
                                                          i_noun);

        nll = nll + nll_single;
        dnll.adjs(:,:,i_adj) = dnll.adjs(:,:,i_adj) + dnll_single.adj;
        dnll.pairs(i_sim,:) = dnll.pairs(i_sim,:);
        dnll.noise = dnll.noise + dnll_single.noise;
        dnll.theta_adj = dnll.theta_adj + dnll_single.theta_adj;
        dnll.theta_noun = dnll.theta_noun + dnll_single.theta_noun;   
    end
end

% TODO regularization

uw_dnll = unwrap(dnll);

end