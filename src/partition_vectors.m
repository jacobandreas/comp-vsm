function [ out_dist_pairs, out_sim_pairs, out_vectors, out_simdata ] = partition_vectors( ...
    in_dist_pairs, in_sim_pairs, in_vectors, in_simdata )
%PARTITION_VECTORS Summary of this function goes here
%   Detailed explanation goes here

out_vectors = [];
out_vectors.adjs = [];
out_vectors.nouns = [];
out_vectors.pairs = [];

out_dist_pairs = [];

index_map = sparse(size(in_vectors,1),1);

next_adj = 1;
next_noun = 1;
next_pair = 1;

for i=1:size(in_dist_pairs,1)
    adj_i = in_dist_pairs(i,1);
    noun_i = in_dist_pairs(i,2);
    pair_i = in_dist_pairs(i,3);
    
    if ~index_map(adj_i)
        out_vectors.adjs(next_adj, :) = in_vectors(adj_i,:);
        index_map(adj_i) = next_adj;
        next_adj = next_adj + 1;
    end
    
    if ~index_map(noun_i)
        out_vectors.nouns(next_noun, :) = in_vectors(noun_i,:);
        index_map(noun_i) = next_noun;
        next_noun = next_noun + 1;
    end
    
    if ~index_map(pair_i)
        out_vectors.pairs(next_pair, :) = in_vectors(pair_i,:);
        index_map(pair_i) = next_pair;
        next_pair = next_pair + 1;
    end
    
    out_dist_pairs(i,:) = [index_map(adj_i), index_map(noun_i), index_map(pair_i)];
end

out_sim_pairs = {};
for i=1:size(in_sim_pairs,1)
    group = in_sim_pairs{i};
    out_group = zeros(size(group));
    for j=1:size(group,1)
        adj = group(j,1);
        noun = group(j,2);
        out_group(j,1) = index_map(adj);
        out_group(j,2) = index_map(noun);
    end
    out_sim_pairs{i} = out_group;
end

out_simdata = [];
out_simdata.scores = in_simdata.scores;
n_sims = size(in_simdata.scores, 1);
out_simdata.adjs1 = zeros(n_sims, 1);
out_simdata.adjs2 = zeros(n_sims, 1);
out_simdata.nouns1 = zeros(n_sims, 1);
out_simdata.nouns2 = zeros(n_sims, 1);

for i=1:n_sims
    out_simdata.adjs1(i) = index_map(in_simdata.adjs1(i));
    out_simdata.adjs2(i) = index_map(in_simdata.adjs2(i));
    out_simdata.nouns1(i) = index_map(in_simdata.nouns1(i));
    out_simdata.nouns2(i) = index_map(in_simdata.nouns2(i));
end

end

