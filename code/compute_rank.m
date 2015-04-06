function rank = compute_rank(histogram_train, histogram_test, feature_params)

num_test = size(histogram_test,1);
num_train = size(histogram_train,1);

rank = zeros(num_test,1);
for i = 1: num_test
    % Rank documents between histogram_test(i,:) and every element in
    %histogram_train using normalized scalar product (cosine of angle)
    rank(i) = 1;% Rank using the paper formula for rank
end

% make a plot like Figure 3b (SA+MS)
