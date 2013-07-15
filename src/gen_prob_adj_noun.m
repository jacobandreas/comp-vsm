function [ nlp, dnlp ] = gen_prob_adj_noun( vec, i_adj, i_noun, params, options )
%POINT_FROM_NOUN Summary of this function goes here
%   Detailed explanation goes here

    noun = vec(1:size(vec)/2);
    pair = vec(size(vec)/2+1:end);

    nlp_prior = (pair' * pair) / 2;
    dnlp_prior__pair = pair;

    [ nlp_adj, dnlp_adj__pair, ~ ] = loglinear_likelihood( pair, params.theta_adj, i_adj );
    
    if options.gen.tie_adjs
        adj = params.adjs;
    else
        adj = params.adjs(:,:,i_adj);
    end
    
    diff = adj * pair - noun;
    nlp_interaction = (diff' * diff) / 2;
    dnlp_interaction__pair = adj' * adj * pair - adj' * noun;
    dnlp_interaction__noun = noun - adj * pair;
    
    [ nlp_noun, dnlp_noun__noun, ~ ] = loglinear_likelihood(noun, params.theta_noun, i_noun);
    
    nlp = nlp_prior + nlp_adj + nlp_interaction + nlp_noun;
    dnlp__pair = dnlp_prior__pair + dnlp_adj__pair + dnlp_interaction__pair;
    dnlp__noun = dnlp_interaction__noun + dnlp_noun__noun;
    
    dnlp = [dnlp__noun; dnlp__pair];
     
%     [ nlp_noun, dnlp_noun, ~ ] = loglinear_likelihood( adj * meaning, params.noun_picker, noun_id );
    
%     scores = params.theta_noun' * adj * pair;
%     scores_exp = exp(scores);
%     denom = logsumexp(scores);
% 
%     nlp_noun = -(scores(i_noun) - denom);
%     dnlp_noun = - adj' * params.theta_noun(:,i_noun) + ...
%         adj' * params.theta_noun * scores_exp / sum(scores_exp);
%     
%     nlp = nlp_pair__pair + nlp_pair__adj + nlp_noun;
%     dnlp = dnlp_pair__pair + dnlp_pair__adj + dnlp_noun;

end