function [ model ] = train_alm( vectors, pairs, options )
%TRAIN_ALM Summary of this function goes here
%   Detailed explanation goes here

model = zeros(options.dim + 1, options.dim, size(vectors, 1));

for i=1:size(vectors, 1)
    
    adj_pair_indices = pairs(pairs(:,1) == i, 2:3);
    if size(adj_pair_indices, 1) == 0
        continue
    end
    
    adj_nouns = vectors(adj_pair_indices(:,1),:);
    adj_pairs = vectors(adj_pair_indices(:,2),:);
    
    [~, ~, ~, ~, beta] = plsregress(adj_nouns, adj_pairs, ...
                                    options.alm.n_components);
                                    
    model(:,:,i) = beta;
    
end

end

