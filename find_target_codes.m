    function [target_codes, para] = find_target_codes(slabel, para)
        % find target codes for a new labeled example
        assert(~isempty(slabel) && sum(slabel) ~= 0, ...
            'Error: finding target codes for unlabeled example');

        if numel(slabel) == 1
            % single-label dataset
            [ismem, ind] = ismember(slabel, para.seen_labels);
            if ~ismem
                ind = para.ECOC_i;
                para.seen_labels = [para.seen_labels; slabel];
                random_x = randn(1, para.nbits);
                random_code = zeros(1, para.nbits);
                random_code(random_x >= 0) = 1;
                
                para.ECOC_M = [para.ECOC_M; 2*random_code-1];
                para.ECOC_i = para.ECOC_i + 1;
            end
        else
            % multi-label dataset
            % find incoming labels that are unseen
            unseen = find(slabel & ~para.seen_labels);
            if ~isempty(unseen)
                for j = unseen
                    
                    random_x = randn(1, para.nbits);
                    random_code = zeros(1, para.nbits);
                    random_code(random_x >= 0) = 1;

                    
                    para.ECOC_M(j, :) = 2*random_code-1;
                    para.ECOC_i = para.ECOC_i + 1;
                end
                para.seen_labels(unseen) = 1;
            end
            ind = find(slabel);
        end
        target_codes = para.ECOC_M(ind, :);
    end

