function [ ] = eval_sim10( name, vectorizer, simdata, varargin )
%EVAL_SIM10 Summary of this function goes here
%   Detailed explanation goes here

%load('data/eval/sim10.mat')
scores = simdata.scores;
adjs1 = simdata.adjs1;
adjs2 = simdata.adjs2;
nouns1 = simdata.nouns1;
nouns2 = simdata.nouns2;

results = zeros(size(scores));

for i=1:size(adjs1,1)
    
    a1 = adjs1(i);
    n1 = nouns1(i);
    a2 = adjs2(i);
    n2 = nouns2(i);
    
%     if a1 == 0 || n1 == 0 || a2 == 0 || n2 == 0
%         continue
%     end
     
    v1 = vectorizer(a1, n1, varargin{:});
    v2 = vectorizer(a2, n2, varargin{:});
    
    dist = 1-pdist([v1'; v2'], 'cosine');
    results(i) = dist;
    
end

%scatter(results, scores);
[rho, p] = corr(scores, results, 'type', 'spearman');
fprintf('evaluating %s\n', name);
fprintf('rho: %f\n', rho);
fprintf('p:   %f\n', p);
fprintf('\n');

end
